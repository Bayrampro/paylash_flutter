// TODO
// Create_devices_list provider
// lib/providers/devices_provider.dart
// lib/providers/devices_provider.dart
// lib/providers/devices_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

final devicesStreamProvider = StreamProvider<List<String>>((ref) {
  final wifiDirectManager = WifiDirectManager();
  return wifiDirectManager.getDiscoveredDevicesStream();
});
