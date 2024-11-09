import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

class IsWifiDirectEnabledNotifier extends StateNotifier<bool> {
  final WifiDirectManager _wifiDirectManager;
  Timer? _timer;

  IsWifiDirectEnabledNotifier(this._wifiDirectManager) : super(false) {
    _startTimer();
  }

  void checkWifiDirect() {
    _wifiDirectManager.isWiFiDirectEnabled().then(
          (value) => state = value,
        );
  }

  void _startTimer() {
    log('Таймер Wifi Direct стартанула!!!');
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        final isEnabled = await _wifiDirectManager.isWiFiDirectEnabled();
        if (state != isEnabled) {
          state = isEnabled;
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final isWifiDirectEnabledProvider =
    StateNotifierProvider<IsWifiDirectEnabledNotifier, bool>((ref) {
  final wifiDirectManager = GetIt.I.get<WifiDirectManager>();
  return IsWifiDirectEnabledNotifier(wifiDirectManager);
});
