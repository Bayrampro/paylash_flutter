package com.bynet.paylash;

import io.flutter.embedding.android.FlutterActivity;

import android.os.Bundle;
import android.net.wifi.p2p.WifiP2pManager;
import android.net.wifi.p2p.WifiP2pManager.Channel;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.bynet.paylash/wifiDirect";
    private WifiP2pManager wifiP2pManager;
    private Channel channel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(getFlutterEngine());

        // Инициализация WifiP2pManager
        wifiP2pManager = (WifiP2pManager) getSystemService(WIFI_P2P_SERVICE);
        channel = wifiP2pManager.initialize(this, getMainLooper(), null);

        // Создание платформенного канала
        new MethodChannel(getFlutterEngine().getDartExecutor(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("discoverDevices")) {
                        discoverDevices(result);
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

    // Метод для обнаружения устройств через Wi-Fi Direct
    private void discoverDevices(MethodChannel.Result result) {
        wifiP2pManager.discoverPeers(channel, new WifiP2pManager.ActionListener() {
            @Override
            public void onSuccess() {
                result.success("Устройства обнаружены");
            }

            @Override
            public void onFailure(int reasonCode) {
                result.error("DISCOVERY_FAILED", "Не удалось обнаружить устройства", null);
            }
        });
    }
}