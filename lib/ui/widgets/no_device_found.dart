import 'package:flutter/material.dart';

class NoDevicesFound extends StatelessWidget {
  const NoDevicesFound({
    super.key,
    required this.onRefresh,
  });

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Töwerekde enjam tapylmady',
            style:
                theme.textTheme.titleLarge?.copyWith(color: theme.canvasColor),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: Icon(
              Icons.refresh,
              size: 50,
              color: theme.canvasColor,
            ),
          )
        ],
      ),
    );
  }
}
