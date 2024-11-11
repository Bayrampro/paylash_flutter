import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:paylash/models/wifi_p2p_device.dart';

class WifiDirectManager {
  static const platform = MethodChannel('com.bynet.paylash/wifiDirect');

  // Метод для запуска обнаружения устройств
  Future<void> discoverDevices() async {
    try {
      await platform.invokeMethod('discoverDevices');
    } on PlatformException catch (e) {
      log("Ошибка при обнаружении устройств: ${e.message}");
    }
  }

  // Метод для получения потока найденных устройств как объектов WifiP2pDevice
  Stream<List<WifiP2pDevice>> getDiscoveredDevicesStream() {
    final StreamController<List<WifiP2pDevice>> deviceStreamController =
        StreamController<List<WifiP2pDevice>>();

    platform.setMethodCallHandler((call) async {
      if (call.method == "discoveredDevices") {
        List<String> deviceStrings = List<String>.from(call.arguments);

        // Преобразуем каждую строку в объект WifiP2pDevice
        List<WifiP2pDevice> devices = deviceStrings.map((deviceString) {
          List<String> details = deviceString.split(',');

          // Убедимся, что у нас есть два элемента - имя и адрес
          if (details.length == 2) {
            String deviceName = details[0];
            String deviceAddress = details[1];
            return WifiP2pDevice(
              deviceName: deviceName,
              deviceAddress: deviceAddress,
            );
          } else {
            // Если формат не соответствует, вернем пустой объект или обработаем ошибку
            return WifiP2pDevice(
              deviceName: "Unknown",
              deviceAddress: "Unknown",
            );
          }
        }).toList();

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

  // Подключение к устройству
  Future<void> connectToDevice(String deviceAddress) async {
    try {
      final result = await platform
          .invokeMethod('connectToDevice', {'deviceAddress': deviceAddress});
      log("Подключение успешно: $result");
    } on PlatformException catch (e) {
      log("Ошибка при подключении к устройству: ${e.message}");
      // Можно дополнительно обработать ошибку в зависимости от кода
      if (e.code == "CONNECTION_FAILED") {
        log("Не удалось подключиться: ${e.message}");
      }
    }
  }

  // Проверка подключен ли устройство
  Future<bool> isDeviceConnect() async {
    try {
      final bool isConnected = await platform.invokeMethod('isDeviceConnected');
      return isConnected;
    } on PlatformException catch (e) {
      log("Ошибка при проверке состояния подключения: ${e.message}");
      return false;
    }
  }

  // Метод для отключения от устройства
  Future<void> disconnectFromDevice() async {
    try {
      await platform.invokeMethod('disconnectFromDevice');
    } on PlatformException catch (e) {
      log("Ошибка при отключении от устройства: ${e.message}");
    }
  }
}
