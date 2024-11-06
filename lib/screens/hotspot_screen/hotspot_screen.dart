// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:paylash/providers/hotspot_provider.dart';

// class HotspotScreen extends ConsumerWidget {
//   const HotspotScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Paýlaş'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await ref
//                       .read(hotspotProvider.notifier)
//                       .openHotspotSettings();
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Ошибка: $e")),
//                   );
//                 }
//               },
//               child: const Text('Открыть настройки точки доступа (Hotspot)'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
