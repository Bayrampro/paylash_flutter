import 'package:flutter/material.dart';
import 'package:paylash/router/router.dart';
import 'package:paylash/ui/theme/theme.dart';

class SharingApp extends StatelessWidget {
  const SharingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Paýlaş",
      theme: theme,
      routerConfig: router,
    );
  }
}
