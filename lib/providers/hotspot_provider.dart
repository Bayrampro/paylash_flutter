import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wifi_iot/wifi_iot.dart';

final hotspotProvider = StateNotifierProvider<HotspotController, bool>((ref) {
  return HotspotController();
});

class HotspotController extends StateNotifier<bool> {
  HotspotController() : super(false);

  Future<void> toggleHotspot() async {
    bool isEnabled = await WiFiForIoTPlugin.isWiFiAPEnabled();
    if (isEnabled) {
      await WiFiForIoTPlugin.setWiFiAPEnabled(false);
    } else {
      await WiFiForIoTPlugin.setWiFiAPEnabled(true);
    }
    state = await WiFiForIoTPlugin.isWiFiAPEnabled();
  }
}
