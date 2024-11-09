import 'package:flutter/material.dart';
import 'package:paylash/router/router.dart';

import '../ui/ui.dart';

class SharingApp extends StatelessWidget {
  const SharingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Paýlaş",
      theme: theme,
      routerConfig: router,
    );
  }
}
