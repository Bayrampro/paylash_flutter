import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylash/app/sharing_app.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final wifiP2P = FlutterP2pConnection();
  // await wifiP2P.initialize();

  final locationStatus = await Permission.location.request();

  if (locationStatus.isGranted) {
    // Future<void> discoverPeers() async {
    //   try {
    //     // await wifiP2P.discover();
    //     log("Процесс обнаружения запущен...");

    //     // final discoveredPeers = await wifiP2P.fetchPeers();

    //     log('$discoveredPeers');

    //     if (discoveredPeers.isEmpty) {
    //       log("Устройства не найдены, повторная попытка...");
    //       await retryDiscoverPeers(wifiP2P);
    //     } else {
    //       for (var peer in discoveredPeers) {
    //         log('Найдено устройство: $peer');
    //       }
    //     }
    //   } catch (e) {
    //     log("Ошибка при обнаружении устройств: $e");
    //   }
    // }

    await WifiDirectManager().discoverDevices();
    runApp(
      const ProviderScope(child: SharingApp()),
    );
  } else {
    log("Не удалось получить необходимые разрешения для работы с Wi-Fi Direct.");
  }
}

// Future<void> retryDiscoverPeers(FlutterP2pConnection wifiP2P) async {
//   try {
//     await wifiP2P.discover();
//     log("Повторный процесс обнаружения запущен...");

//     final discoveredPeers = await wifiP2P.fetchPeers();
//     if (discoveredPeers.isEmpty) {
//       log("Устройства не найдены при повторном обнаружении.");
//       await Future.delayed(const Duration(seconds: 3));
//       retryDiscoverPeers(wifiP2P);
//     } else {
//       for (var peer in discoveredPeers) {
//         log('Найдено устройство: $peer');
//       }
//     }
//   } catch (e) {
//     log("Ошибка при повторном обнаружении устройств: $e");
//   }
// }
