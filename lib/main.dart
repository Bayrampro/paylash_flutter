import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paylash/app/sharing_app.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request location permission using Geolocator
  bool permissionGranted = await _checkLocationPermission();

  if (permissionGranted) {
    // Permission granted, enable Wi-Fi Direct and start discovering devices
    try {
      await WifiDirectManager().discoverDevices();
    } catch (e) {
      log("Error during device discovery: $e");
    }

    // Run the app after Wi-Fi Direct setup is complete
    runApp(
      const ProviderScope(
        child: SharingApp(),
      ),
    );
  } else {
    // Log an error if location permission is not granted
    log("Location permission is not granted, unable to proceed with Wi-Fi Direct.");
  }
}

// Method to check location permission
Future<bool> _checkLocationPermission() async {
  bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isLocationServiceEnabled) {
    log("Location services are disabled. Please enable them.");
    return false;
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    // Request permission if denied
    permission = await Geolocator.requestPermission();
  }

  return permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always;
}
