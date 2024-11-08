import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

final devicesProvider = StreamProvider<List<String>>((ref) {
  final wifiDirectManager = WifiDirectManager();
  wifiDirectManager.discoverDevices(); // Запуск обнаружения
  return wifiDirectManager.getDiscoveredDevicesStream();
});

class DevicesListScreen extends ConsumerWidget {
  const DevicesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsyncValue = ref.watch(devicesProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            context.go("/");
          },
          child: const Text("PAÝLAŞ"),
        ),
      ),
      body: devicesAsyncValue.when(
        data: (devices) => devices.isNotEmpty
            ? ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final deviceName = devices[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(deviceName),
                        subtitle: const Text("Tap to connect"),
                        onTap: () {
                          // Логика подключения к устройству
                        },
                      ),
                    ),
                  );
                },
              )
            : const Center(child: Text("Нет доступных устройств")),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Ошибка: $error")),
      ),
    );
  }
}
