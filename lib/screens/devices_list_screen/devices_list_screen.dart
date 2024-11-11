import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:paylash/providers/devices_list_provider.dart';
import 'package:paylash/providers/is_device_connected_provider.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

import '../../ui/ui.dart';

class DevicesListScreen extends ConsumerWidget {
  const DevicesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsyncValue = ref.watch(devicesProvider);
    final isDeviceConnected = ref.watch(isDeviceConnectedProvider);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (isDeviceConnected) {
          context.go('/file-picker');
        }
      },
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SimpleAppBar(
          iconData: Icons.arrow_back,
          onBack: () => context.go('/'),
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
                  final device = devices[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: DeviceListItem(
                      deviceName: device.deviceName,
                      onConnect: () {
                        WifiDirectManager()
                            .connectToDevice(device.deviceAddress);
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
