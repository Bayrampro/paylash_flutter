import 'package:flutter/material.dart';
import 'package:paylash/theme/theme.dart';

import 'features/hotspot/views/hotspot_screen.dart';

class SharingApp extends StatelessWidget {
  const SharingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Paýlaş",
      theme: themes,
      home: const HotspotScreen(),
    );
  }
}
