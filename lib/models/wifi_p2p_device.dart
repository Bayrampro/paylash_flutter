//TODO: json_anotation add
class WifiP2pDevice {
  final String deviceName;
  final String deviceAddress;

  WifiP2pDevice({
    required this.deviceName,
    required this.deviceAddress,
  });

  // Метод для создания объекта WifiP2pDevice из Map
  factory WifiP2pDevice.fromMap(Map<String, dynamic> map) {
    return WifiP2pDevice(
      deviceName: map['deviceName'] ?? '',
      deviceAddress: map['deviceAddress'] ?? '',
    );
  }

  // Метод для преобразования объекта в Map
  Map<String, dynamic> toMap() {
    return {
      'deviceName': deviceName,
      'deviceAddress': deviceAddress,
    };
  }
}
