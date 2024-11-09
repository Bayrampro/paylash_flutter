import 'package:flutter/material.dart';

class EnableButtonItem extends StatelessWidget {
  const EnableButtonItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Icon icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: icon,
        tileColor: theme.canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onTap: onTap,
      ),
    );
  }
}
