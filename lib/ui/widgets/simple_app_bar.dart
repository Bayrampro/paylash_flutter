import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget {
  const SimpleAppBar({
    super.key,
    this.actions,
    required this.onBack,
    required this.iconData,
  });

  final List<Widget>? actions;
  final VoidCallback onBack;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onBack,
        icon: Icon(iconData),
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
