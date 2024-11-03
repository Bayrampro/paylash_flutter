import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paylash/providers/hotspot_provider.dart';

class HotspotScreen extends ConsumerWidget {
  const HotspotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotspotEnabled = ref.watch(hotspotProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paýlaş'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hotspot is ${hotspotEnabled ? 'AÇ' : "ÖÇÜR"}",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await ref.read(hotspotProvider.notifier).toggleHotspot();
                },
                child: Text(hotspotEnabled ? 'Hotspoty Öçür' : "Hotspoty aç")),
          ],
        ),
      ),
    );
  }
}
