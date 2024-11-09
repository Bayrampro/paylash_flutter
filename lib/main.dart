import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:paylash/app/sharing_app.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerLazySingleton<WifiDirectManager>(() => WifiDirectManager());

  runApp(
    const ProviderScope(
      child: SharingApp(),
    ),
  );
}
