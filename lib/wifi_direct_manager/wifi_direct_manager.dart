import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';

class WifiDirectManager {
  static const platform = MethodChannel('com.bynet.paylash/wifiDirect');

  // Метод для запуска обнаружения устройств и получения списка устройств
  Future<void> discoverDevices() async {
    try {
      await platform.invokeMethod('discoverDevices');
    } on PlatformException catch (e) {
      log("Ошибка при обнаружении устройств: ${e.message}");
    }
  }

  Stream<List<String>> getDiscoveredDevicesStream() {
    final StreamController<List<String>> deviceStreamController =
        StreamController<List<String>>();

    platform.setMethodCallHandler((call) async {
      if (call.method == "discoveredDevices") {
        List<String> devices = List<String>.from(call.arguments);
        deviceStreamController.add(devices);
      }
    });

    return deviceStreamController.stream;
  }

  // Метод для включения Wi-Fi Direct
  Future<void> enableWiFiDirect() async {
    try {
      await platform.invokeMethod('enableWiFiDirect');
    } on PlatformException catch (e) {
      log("Ошибка при включении Wi-Fi Direct: ${e.message}");
    }
  }
}
