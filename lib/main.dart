import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylash/app/sharing_app.dart';

void main() {
  runApp(
    const ProviderScope(child: SharingApp()),
  );
}
