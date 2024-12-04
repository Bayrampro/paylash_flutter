package com.bynet.paylash;

import android.net.wifi.p2p.WifiP2pInfo;
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
import android.net.Uri;

import android.provider.MediaStore;
import android.provider.MediaStore.Images;

import android.database.Cursor; // For querying the content resolver
import android.net.Uri; // For handling URIs
import android.provider.MediaStore; // For accessing media files
import android.util.Log; // For logging errors
import java.util.ArrayList; // For storing file paths

import android.Manifest;
import android.content.pm.PackageManager;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.bynet.paylash/wifiDirect";
    private static final String FILE_PICKER_CHANNEL = "com.bynet.paylash/filePicker"; // Новый канал для файлов

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
                        case "disconnectFromDevice":
                            disconnectFromDevice(result);
                            break;
                        case "connectToDevice":
                            String deviceAddress = call.argument("deviceAddress");
                            connectToDevice(deviceAddress, result);
                            break;
                        case "isDeviceConnected":
                            isDeviceConnected(isConnected -> result.success(isConnected));
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

        // Новый канал для работы с файлами
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), FILE_PICKER_CHANNEL)
                .setMethodCallHandler((call, result) ->

                {
                    if (call.method.equals("fetchFiles")) {
                        String fileType = call.argument("fileType");
                        ArrayList<String> files = fetchFiles(fileType);
                        result.success(files);
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private ArrayList<String> fetchFiles(String fileType) {
        ArrayList<String> files = new ArrayList<>();
        Uri uri;
        String[] projection;

        // Определяем типы файлов для запроса
        switch (fileType) {
            case "images":
                uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                projection = new String[] { MediaStore.Images.Media.DATA };
                break;
            case "videos":
                uri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                projection = new String[] { MediaStore.Video.Media.DATA };
                break;
            case "audio":
                uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                projection = new String[] { MediaStore.Audio.Media.DATA };
                break;
            default: // Для всех типов файлов
                uri = MediaStore.Files.getContentUri("external");
                projection = new String[] { MediaStore.Files.FileColumns.DATA };
                break;
        }

        // Выполняем запрос через ContentResolver
        try (Cursor cursor = getContentResolver().query(uri, projection, null, null, null)) {
            if (cursor != null) {
                int columnIndex = cursor.getColumnIndexOrThrow(projection[0]);
                while (cursor.moveToNext()) {
                    String filePath = cursor.getString(columnIndex);
                    // Проверяем, находится ли файл в памяти устройства
                    if (filePath.startsWith("/storage/emulated/0/")) {
                        files.add(filePath);
                    }
                }
            }
        } catch (Exception e) {
            Log.e("FilePicker", "Ошибка при получении файлов: " + e.getMessage());
        }

        return files;
    }

    private void requestStoragePermissions() {
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[] { Manifest.permission.READ_EXTERNAL_STORAGE }, 1);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestStoragePermissions();
    }

    // Метод для отключения от устройства
    // private void disconnectFromDevice(MethodChannel.Result result) {
    // wifiP2pManager.cancelConnect(channel, new WifiP2pManager.ActionListener() {
    // @Override
    // public void onSuccess() {
    // result.success("Устройство успешно отключено");
    // }

    // @Override
    // public void onFailure(int reason) {
    // result.error("DISCONNECT_FAILED", "Не удалось отключиться от устройства",
    // null);
    // }
    // });
    // }

    private void disconnectFromDevice(MethodChannel.Result result) {

        wifiP2pManager.requestConnectionInfo(channel, info -> {
            if (info.groupFormed) {
                wifiP2pManager.removeGroup(channel, new WifiP2pManager.ActionListener() {
                    @Override
                    public void onSuccess() {
                        result.success("Устройство успешно отключено");
                    }

                    @Override
                    public void onFailure(int reason) {
                        String errorMessage;
                        switch (reason) {
                            case WifiP2pManager.BUSY:
                                errorMessage = "Система занята";
                                break;
                            case WifiP2pManager.ERROR:
                                errorMessage = "Произошла ошибка";
                                break;
                            case WifiP2pManager.P2P_UNSUPPORTED:
                                errorMessage = "P2P не поддерживается на этом устройстве";
                                break;
                            default:
                                errorMessage = "Неизвестная ошибка";
                                break;
                        }
                        result.error("DISCONNECT_FAILED", "Не удалось отключиться от устройства" + errorMessage, null);
                    }
                });
            } else {
                result.success("Устройство уже отключено");
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

    // Метод для проверки подключения устройства с использованием callback
    public interface BooleanCallback {
        void onResult(boolean result);
    }

    private void isDeviceConnected(BooleanCallback callback) {
        wifiP2pManager.requestConnectionInfo(channel, info -> {
            callback.onResult(info.groupFormed);
        });
    }

    // Проверка и включение геолокации, если она выключена
    private void enableLocationIfNecessary() {
        if (!isLocationEnabled()) {
            Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
            startActivityForResult(intent, 0);
        }
    }

    private boolean isLocationEnabled() {
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
        return ActivityCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED;
    }

    // Запрос разрешения на использование местоположения
    private void requestLocationPermission() {
        ActivityCompat.requestPermissions(this, new String[] { Manifest.permission.ACCESS_FINE_LOCATION },
                REQUEST_LOCATION_PERMISSION);
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
        MethodChannel methodChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(),
                CHANNEL);
        List<String> deviceInfoListAsString = new ArrayList<>();

        // Преобразуем каждый элемент в строку (например, формат deviceName,
        // deviceAddress)
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
