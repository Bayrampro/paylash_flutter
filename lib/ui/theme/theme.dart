import 'package:flutter/material.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF0cc0df),
  ),
  scaffoldBackgroundColor: const Color(0xFF0cc0df),
  textTheme: TextTheme(
    titleLarge:
        const TextStyle().copyWith(fontWeight: FontWeight.w800, fontSize: 20),
  ),
);
