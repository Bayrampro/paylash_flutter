import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:paylash/models/wifi_p2p_device.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

final streamRefreshTriggerProvider = StateProvider<int>((ref) => 0);

final devicesProvider = StreamProvider<List<WifiP2pDevice>>((ref) {
  ref.watch(streamRefreshTriggerProvider);

  final wifiDirectManager = GetIt.I.get<WifiDirectManager>();
  wifiDirectManager.discoverDevices();
  return wifiDirectManager.getDiscoveredDevicesStream().timeout(
        const Duration(seconds: 15),
      );
});
