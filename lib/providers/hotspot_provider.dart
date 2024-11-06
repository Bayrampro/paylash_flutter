// import 'dart:async';

// import 'package:android_intent_plus/android_intent.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:permission_handler/permission_handler.dart';

// final hotspotProvider = StateNotifierProvider<HotspotController, bool>((ref) {
//   return HotspotController();
// });

// class HotspotController extends StateNotifier<bool> {
//   HotspotController() : super(false);

//   Future<void> openHotspotSettings() async {
//     if (await _requestPermissions()) {
//       try {
//         const intent = AndroidIntent(
//           action: 'android.settings.TETHER_SETTINGS',
//         );
//         await intent.launch();
//       } on PlatformException catch (e) {
//         print("PlatformException: ${e.message}");
//       } catch (e) {
//         print("Неизвестная ошибка: $e");
//       }
//     } else {
//       print("Необходимы разрешения для местоположения и записи.");
//     }
//   }

//   Future<bool> _requestPermissions() async {
//     final locationStatus = await Permission.location.request();
//     return locationStatus.isGranted;
//   }
// }
