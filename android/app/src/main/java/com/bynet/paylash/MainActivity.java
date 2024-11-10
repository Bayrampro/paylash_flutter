package com.bynet.paylash;

import android.net.wifi.p2p.WifiP2pConfig;
import android.net.wifi.WifiManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.wifi.p2p.WifiP2pDevice;
import android.net.wifi.p2p.WifiP2pDeviceList;
import android.net.wifi.p2p.WifiP2pManager;
import android.net.wifi.p2p.WifiP2pManager.Channel;
import android.net.wifi.p2p.WifiP2pManager.PeerListListener;
import android.provider.Settings;
import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import androidx.core.app.ActivityCompat;
import android.Manifest;
import android.content.pm.PackageManager;
import android.location.LocationManager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.bynet.paylash/wifiDirect";
    private WifiP2pManager wifiP2pManager;
    private Channel channel;
    private static final int REQUEST_LOCATION_PERMISSION = 1;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        wifiP2pManager = (WifiP2pManager) getSystemService(WIFI_P2P_SERVICE);
        channel = wifiP2pManager.initialize(this, getMainLooper(), null);

        // Register the receiver to detect Wi-Fi Direct devices
        registerReceiver(wifiP2pReceiver, new IntentFilter(WifiP2pManager.WIFI_P2P_PEERS_CHANGED_ACTION));

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                switch (call.method) {
                    case "discoverDevices":
                        startDeviceDiscovery(result);
                        break;
                    case "connectToDevice":
                        String deviceAddress = call.argument("deviceAddress");
                        connectToDevice(deviceAddress, result);
                        break;    
                    case "isLocationEnabled":
                        result.success(isLocationEnabled());
                        break;
                    case "enableLocation":
                        enableLocationIfNecessary();
                        result.success(null);
                        break;
                    case "isWiFiDirectEnabled":
                        result.success(isWiFiDirectEnabled());
                        break;
                    case "enableWiFiDirect":
                        enableWiFiDirectIfNecessary();
                        result.success(null);
                        break;
                    default:
                        result.notImplemented();
                        break;
                }
            });
    }

    // Метод для подключения к выбранному устройству через Wi-Fi Direct
    private void connectToDevice(String deviceAddress, MethodChannel.Result result) {
        WifiP2pConfig config = new WifiP2pConfig();
        config.deviceAddress = deviceAddress; // Устанавливаем MAC-адрес выбранного устройства

        wifiP2pManager.connect(channel, config, new WifiP2pManager.ActionListener() {
            @Override
            public void onSuccess() {
                result.success("Подключение к устройству " + deviceAddress + " прошло успешно");
            }

            @Override
            public void onFailure(int reasonCode) {
                result.error("CONNECTION_FAILED", "Не удалось подключиться к устройству: " + deviceAddress, null);
            }
        });
    }

    // Проверка и включение геолокации, если она выключена
    private void enableLocationIfNecessary() {
        if (!isLocationEnabled()) {
            Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
            startActivityForResult(intent, 0);
        }
    }

    private boolean isLocationEnabled(){
        LocationManager locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
                || locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
    }

    // Метод для включения Wi-Fi Direct
    private void enableWiFiDirectIfNecessary() {
        if (!isWiFiDirectEnabled()) {
            Intent intent = new Intent(Settings.ACTION_WIFI_SETTINGS);
            startActivity(intent);
        }
    }

    // Метод для проверки включенности Wi-Fi Direct
    private boolean isWiFiDirectEnabled() {
        WifiManager wifiManager = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);
        return wifiManager.isWifiEnabled();
    }

    // Метод для начала обнаружения устройств
    private void startDeviceDiscovery(MethodChannel.Result result) {
        if (isLocationPermissionGranted()) {
            wifiP2pManager.discoverPeers(channel, new WifiP2pManager.ActionListener() {
                @Override
                public void onSuccess() {
                    result.success("Discovery started");
                }

                @Override
                public void onFailure(int reasonCode) {
                    result.error("DISCOVERY_FAILED", "Device discovery failed", null);
                }
            });
        } else {
            requestLocationPermission();
            result.error("LOCATION_PERMISSION_REQUIRED", "Location permission is required for Wi-Fi Direct", null);
        }
    }

    // Проверка разрешения на использование местоположения
    private boolean isLocationPermissionGranted() {
        return ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }

    // Запрос разрешения на использование местоположения
    private void requestLocationPermission() {
        ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_LOCATION_PERMISSION);
    }

    // Приемник для обработки Wi-Fi Direct событий
    private final BroadcastReceiver wifiP2pReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (WifiP2pManager.WIFI_P2P_PEERS_CHANGED_ACTION.equals(action)) {
                wifiP2pManager.requestPeers(channel, peerListListener);
            }
        }
    };

    // Обработчик списка доступных устройств
    private final PeerListListener peerListListener = new PeerListListener() {
        @Override
        public void onPeersAvailable(WifiP2pDeviceList peerList) {
            List<Map<String, String>> deviceInfoList = new ArrayList<>();

            for (WifiP2pDevice device : peerList.getDeviceList()) {
                Map<String, String> deviceInfo = new HashMap<>();
                deviceInfo.put("deviceName", device.deviceName);
                deviceInfo.put("deviceAddress", device.deviceAddress);
                deviceInfoList.add(deviceInfo);
            }

            sendDiscoveredDevicesToFlutter(deviceInfoList);
        }
    };

    private void sendDiscoveredDevicesToFlutter(List<Map<String, String>> deviceInfoList) {
        MethodChannel methodChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL);
        List<String> deviceInfoListAsString = new ArrayList<>();

        // Преобразуем каждый элемент в строку (например, формат deviceName, deviceAddress)
        for (Map<String, String> deviceInfo : deviceInfoList) {
            String deviceName = deviceInfo.get("deviceName");
            String deviceAddress = deviceInfo.get("deviceAddress");
            deviceInfoListAsString.add(deviceName + "," + deviceAddress);
        }

        // Отправляем список строк в Flutter
        methodChannel.invokeMethod("discoveredDevices", deviceInfoListAsString);
    }


    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(wifiP2pReceiver);
    }
}

