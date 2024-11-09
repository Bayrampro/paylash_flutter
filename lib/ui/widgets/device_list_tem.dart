import 'package:flutter/material.dart';

class DeviceListItem extends StatelessWidget {
  const DeviceListItem({
    super.key,
    required this.deviceName,
    required this.onConnect,
  });

  final String deviceName;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(deviceName),
        subtitle: const Text("Bas çatylmak üçin"),
        trailing: const Icon(Icons.smartphone),
        onTap: onConnect,
      ),
    );
  }
}
