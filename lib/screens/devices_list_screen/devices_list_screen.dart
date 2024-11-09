import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylash/providers/devices_list_provider.dart';

import '../../ui/ui.dart';

class DevicesListScreen extends ConsumerWidget {
  const DevicesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsyncValue = ref.watch(devicesProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SimpleAppBar(
          actions: [
            devicesAsyncValue.when(
              data: (data) => IconButton(
                onPressed: () =>
                    ref.read(streamRefreshTriggerProvider.notifier).state++,
                icon: const Icon(
                  Icons.refresh,
                  size: 30,
                ),
              ),
              error: (error, stackTrace) => Container(),
              loading: () => Container(),
            )
          ],
        ),
      ),
      body: devicesAsyncValue.when<Widget>(
        data: (devices) => devices.isNotEmpty
            ? ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final deviceName = devices[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: DeviceListItem(
                      deviceName: deviceName,
                      onConnect: () {
                        //TODO: Логика подключения к устройству
                      },
                    ),
                  );
                },
              )
            : NoDevicesFound(
                onRefresh: () =>
                    ref.read(streamRefreshTriggerProvider.notifier).state++,
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => NoDevicesFound(
          onRefresh: () =>
              ref.read(streamRefreshTriggerProvider.notifier).state++,
        ),
      ),
    );
  }
}
