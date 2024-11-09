import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

class IsLocationEnabledNotifier extends StateNotifier<bool> {
  final WifiDirectManager _wifiDirectManager;
  Timer? _timer;

  IsLocationEnabledNotifier(this._wifiDirectManager) : super(false) {
    _startTimer();
  }

  void checkLocation() {
    _wifiDirectManager.isLocationEnabled().then((value) => state = value);
  }

  void _startTimer() {
    log('Таймер локации стартанула!!!');
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        final isEnabled = await _wifiDirectManager.isLocationEnabled();
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

final isLocationEnabledProvider =
    StateNotifierProvider<IsLocationEnabledNotifier, bool>((ref) {
  final wifiDirectManager = GetIt.I.get<WifiDirectManager>();
  return IsLocationEnabledNotifier(wifiDirectManager);
});
