import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:paylash/providers/is_loaction_enabled_provider.dart';
import 'package:paylash/providers/is_wifi_direct_enabled_provider.dart';
import 'package:paylash/wifi_direct_manager/wifi_direct_manager.dart';

import '../../ui/ui.dart';

class EnableButtonsScreen extends ConsumerWidget {
  const EnableButtonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocationEnabled = ref.watch(isLocationEnabledProvider);
    final isWifiDirectEnabled = ref.watch(isWifiDirectEnabledProvider);
    final wifiDirectManager = GetIt.I.get<WifiDirectManager>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SimpleAppBar(
          iconData: Icons.arrow_back,
          onBack: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          EnableButtonItem(
            title: !isWifiDirectEnabled ? 'Wifi Direct açylmadyk' : 'Wifi açyk',
            subtitle: !isWifiDirectEnabled ? 'Bas açmak üçin' : 'taýýar',
            icon: !isWifiDirectEnabled
                ? Icon(
                    Icons.wifi_off_outlined,
                    color: theme.colorScheme.error,
                  )
                : const Icon(
                    Icons.wifi_outlined,
                    color: Colors.green,
                  ),
            onTap: !isWifiDirectEnabled
                ? () async => await wifiDirectManager.enableWiFiDirect()
                : null,
          ),
          EnableButtonItem(
            title:
                !isLocationEnabled ? 'Geolokasiýa ýapyk' : 'Geolokasiýa açyk',
            subtitle: !isLocationEnabled ? 'Bas açmak üçin' : 'taýýar',
            icon: !isLocationEnabled
                ? Icon(
                    Icons.location_off_sharp,
                    color: theme.colorScheme.error,
                  )
                : const Icon(
                    Icons.location_on,
                    color: Colors.green,
                  ),
            onTap: !isLocationEnabled
                ? () async => await wifiDirectManager.enableLocation()
                : null,
          ),
        ],
      ),
    );
  }
}
