import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:paylash/providers/is_device_connected_provider.dart';
import 'package:paylash/ui/ui.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

class FilePickerScreen extends ConsumerWidget {
  const FilePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeviceConnected = ref.watch(isDeviceConnectedProvider);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!isDeviceConnected) {
          context.go('/devices');
        }
      },
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SimpleAppBar(
          iconData: Icons.signal_wifi_connected_no_internet_4_sharp,
          onBack: () async =>
              await GetIt.I.get<WifiDirectManager>().disconnectFromDevice(),
        ),
      ),
    );
  }
}
