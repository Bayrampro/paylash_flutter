// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:paylash/providers/is_device_connected_provider.dart';

// class WaitingForConnectionScreen extends ConsumerWidget {
//   final String deviceName;

//   const WaitingForConnectionScreen({
//     super.key,
//     required this.deviceName,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.listen<bool>(
//       isDeviceConnectedProvider,
//       (previous, isConnected) {
//         if (isConnected) {
//           // Navigate to the next screen
//           Navigator.pushReplacementNamed(context, '/waiting-for-file-transfer');
//         }
//       },
//     );

//     final isConnected = ref.watch(isDeviceConnectedProvider);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         centerTitle: true,
//         title: Text(
//           'Waiting for Connection',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.blueGrey[800],
//           ),
//         ),
//       ),
//       body: Center(
//         child: isConnected
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.check_circle,
//                     color: Colors.green,
//                     size: size.height * 0.2,
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Device Connected!',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.green[700],
//                     ),
//                   ),
//                 ],
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: size.height * 0.2,
//                     width: size.height * 0.2,
//                     child: const CircularProgressIndicator(
//                       strokeWidth: 8,
//                       color: Colors.blue,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Connecting to: $deviceName',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.blueGrey,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Please wait...',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 40,
//                         vertical: 15,
//                       ),
//                       backgroundColor: Colors.redAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     onPressed: () {
//                       context.go('/');
//                     },
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:paylash/providers/is_device_connected_provider.dart';
// import 'package:paylash/screens/waiting_for_file_transfer_screen/waiting_for_file_transfer_screen.dart';

// class WaitingForConnectionScreen extends ConsumerWidget {
//   final String deviceName;

//   const WaitingForConnectionScreen({
//     super.key,
//     required this.deviceName,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Слушаем состояние подключения
//     ref.listen<bool>(
//       isDeviceConnectedProvider,
//       (previous, isConnected) {
//         if (isConnected) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => WaitingForFileTransferScreen(
//                   deviceName: deviceName,
//                   deviceNames: const [],
//                 ),
//               ),
//             );
//           });
//         }
//       },
//     );

//     final isConnected = ref.watch(isDeviceConnectedProvider);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         centerTitle: true,
//         title: Text(
//           'Ожидание подключения',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.blueGrey[800],
//           ),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               isConnected
//                   ? 'Устройство подключено!'
//                   : 'Подключаемся к: $deviceName...',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: isConnected ? Colors.green : Colors.blueGrey,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             if (!isConnected)
//               const CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation(Colors.blue),
//               ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 40,
//                   vertical: 15,
//                 ),
//                 backgroundColor: Colors.redAccent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               onPressed: () {
//                 context.go('/');
//               },
//               child: const Text(
//                 'Отменить',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:paylash/providers/is_device_connected_provider.dart';

class WaitingForConnectionScreen extends ConsumerWidget {
  final String deviceName;

  const WaitingForConnectionScreen({
    super.key,
    required this.deviceName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Слушаем состояние подключения
    ref.listen<bool>(
      isDeviceConnectedProvider,
      (previous, isConnected) {
        if (isConnected) {
          log('Состояние isDeviceConnectedProvider: $isConnected');
          // Переход на WaitingForFileTransferScreen через go_router
          log('Переход на экран передачи файлов: /waiting-for-file-transfer с deviceName = $deviceName');
          context.go(
            '/waiting-for-file-transfer',
            extra: deviceName, // Передача имени устройства
          );
        }
      },
    );

    final isConnected = ref.watch(isDeviceConnectedProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Ожидание подключения',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isConnected
                  ? 'Устройство подключено!'
                  : 'Подключаемся к: $deviceName...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isConnected ? Colors.green : Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (!isConnected)
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                context.go('/'); // Возвращаемся на главную
              },
              child: const Text(
                'Отменить',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
