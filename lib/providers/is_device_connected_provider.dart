import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

class IsDeviceConnectedNotifier extends StateNotifier<bool> {
  final WifiDirectManager _wifiDirectManager;
  Timer? _timer;

  IsDeviceConnectedNotifier(this._wifiDirectManager) : super(false) {
    _startTimer();
  }

  void _startTimer() {
    log('Таймер статус подключение стартанула!!!');
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) async {
        final isConnect = await _wifiDirectManager.isDeviceConnect();
        if (state != isConnect) {
          state = isConnect;
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

final isDeviceConnectedProvider =
    StateNotifierProvider<IsDeviceConnectedNotifier, bool>((ref) {
  final wifiDirectManager = GetIt.I.get<WifiDirectManager>();
  return IsDeviceConnectedNotifier(wifiDirectManager);
});
