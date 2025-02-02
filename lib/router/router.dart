import 'package:go_router/go_router.dart';
import 'package:paylash/screens/devices_list_screen/devices_list_screen.dart';
import 'package:paylash/screens/enable_buttons_screen/enable_buttons_screen.dart';
import 'package:paylash/screens/file_picker_screen/file_picker_screen.dart';
import 'package:paylash/screens/file_transfer_screen/file_transfer_screen.dart';
import 'package:paylash/screens/home_screen/home_screen.dart';
import 'package:paylash/screens/waiting_for_connection_screen/waiting_for_connection_screen.dart';
import 'package:paylash/screens/waiting_for_file_transfer_screen/waiting_for_file_transfer_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/devices',
      name: 'devices',
      builder: (context, state) => const DevicesListScreen(),
    ),
    GoRoute(
      path: '/enable',
      name: 'enable',
      builder: (context, state) => const EnableButtonsScreen(),
    ),
    GoRoute(
      path: '/file-picker',
      name: 'file-picker',
      builder: (context, state) => const FilePickerScreen(),
    ),
    GoRoute(
      path: '/waiting-for-connection',
      name: "waiting-for-connection",
      builder: (context, state) {
        final deviceName = state.uri.queryParameters['deviceName'] ?? '';
        return WaitingForConnectionScreen(deviceName: deviceName);
      },
    ),
    GoRoute(
      path: '/waiting-for-file-transfer',
      builder: (context, state) {
        final deviceName = state.extra as String? ?? 'Неизвестное устройство';
        return WaitingForFileTransferScreen(deviceName: deviceName);
      },
    ),
    GoRoute(
      path: '/file-transfer',
      builder: (context, state) {
        final selectedFiles = state.extra as List<String>;
        return FileTransferScreen(selectedFiles: selectedFiles);
      },
    ),
  ],
);
