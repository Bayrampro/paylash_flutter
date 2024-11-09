import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SimpleAppBar extends StatelessWidget {
  const SimpleAppBar({
    super.key,
    this.actions,
  });

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => context.go('/'),
        icon: const Icon(Icons.arrow_back),
      ),
      toolbarHeight: 80,
      centerTitle: true,
      title: Image.asset(
        'assets/app_bar_logo.png',
        width: 70,
        height: 70,
      ),
      actions: actions,
    );
  }
}
