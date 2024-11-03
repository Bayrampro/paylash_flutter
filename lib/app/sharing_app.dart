import 'package:flutter/material.dart';
import 'package:paylash/ui/theme/theme.dart';

import '../screens/hotspot_screen/hotspot_screen.dart';

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
