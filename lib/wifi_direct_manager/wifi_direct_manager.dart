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

  // Проверка включена ли геолокация
  Future<bool> isLocationEnabled() async {
    try {
      final bool result = await platform.invokeMethod('isLocationEnabled');
      return result;
    } on PlatformException catch (e) {
      log("Ошибка при проверке геолокации: ${e.message}");
      return false;
    }
  }

  // Включение геолокации
  Future<void> enableLocation() async {
    try {
      await platform.invokeMethod('enableLocation');
    } on PlatformException catch (e) {
      log("Ошибка при включении геолокации: ${e.message}");
    }
  }

  // Проверка включен ли Wi-Fi Direct
  Future<bool> isWiFiDirectEnabled() async {
    try {
      final bool result = await platform.invokeMethod('isWiFiDirectEnabled');
      return result;
    } on PlatformException catch (e) {
      log("Ошибка при проверке Wi-Fi Direct: ${e.message}");
      return false;
    }
  }

  // Включение Wi-Fi Direct
  Future<void> enableWiFiDirect() async {
    try {
      await platform.invokeMethod('enableWiFiDirect');
    } on PlatformException catch (e) {
      log("Ошибка при включении Wi-Fi Direct: ${e.message}");
    }
  }
}
