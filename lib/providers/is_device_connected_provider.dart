// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get_it/get_it.dart';
// import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

// class IsDeviceConnectedNotifier extends StateNotifier<bool> {
//   final WifiDirectManager _wifiDirectManager;
//   Timer? _timer;

//   IsDeviceConnectedNotifier(this._wifiDirectManager) : super(false) {
//     _startTimer();
//   }

//   void _startTimer() {
//     log('Таймер статус подключение стартанула!!!');
//     _timer = Timer.periodic(
//       const Duration(seconds: 1),
//       (_) async {
//         final isConnect = await _wifiDirectManager.isDeviceConnect();
//         if (state != isConnect) {
//           state = isConnect;
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
// }

// final isDeviceConnectedProvider =
//     StateNotifierProvider<IsDeviceConnectedNotifier, bool>((ref) {
//   final wifiDirectManager = GetIt.I.get<WifiDirectManager>();
//   return IsDeviceConnectedNotifier(wifiDirectManager);
// });

import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

/// Notifier для отслеживания подключения устройства.
class IsDeviceConnectedNotifier extends StateNotifier<bool> {
  final WifiDirectManager _wifiDirectManager;
  Timer? _timer;
  bool _isChecking = false;

  /// Конструктор с инициализацией состояния.
  IsDeviceConnectedNotifier(this._wifiDirectManager) : super(false) {
    _startMonitoringConnection();
  }

  /// Запускает таймер для проверки подключения устройства.
  void _startMonitoringConnection() {
    log('Старт мониторинга подключения...');
    _timer = Timer.periodic(
      const Duration(seconds: 2), // Интервал увеличен для снижения нагрузки
      (_) async {
        if (_isChecking) return; // Предотвращаем наложение вызовов
        _isChecking = true;
        try {
          final isConnected = await _wifiDirectManager.isDeviceConnect();
          if (state != isConnected) {
            log('Состояние подключения изменилось: $isConnected');
            state = isConnected;
          }
        } catch (e, stackTrace) {
          log('Ошибка при проверке подключения: $e\n$stackTrace');
        } finally {
          _isChecking = false;
        }
      },
    );
  }

  /// Очистка таймера при завершении.
  @override
  void dispose() {
    log('Остановка мониторинга подключения...');
    _timer?.cancel();
    super.dispose();
  }
}

/// Провайдер состояния подключения устройства.
final isDeviceConnectedProvider =
    StateNotifierProvider<IsDeviceConnectedNotifier, bool>((ref) {
  final wifiDirectManager = GetIt.I.get<WifiDirectManager>();
  return IsDeviceConnectedNotifier(wifiDirectManager);
});
