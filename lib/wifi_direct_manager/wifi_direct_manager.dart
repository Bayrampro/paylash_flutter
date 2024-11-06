import 'package:flutter/services.dart';

class WifiDirectManager {
  static const platform = MethodChannel('com.bynet.paylash/wifiDirect');

  // Метод для запуска обнаружения устройств
  Future<void> discoverDevices() async {
    try {
      final result = await platform.invokeMethod('discoverDevices');
      print("Обнаружены устройства: $result");
    } on PlatformException catch (e) {
      print("Ошибка при обнаружении устройств: ${e.message}");
    }
  }
}
