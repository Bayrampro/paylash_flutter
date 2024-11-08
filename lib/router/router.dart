import 'package:go_router/go_router.dart';
import 'package:paylash/screens/devices_list_screen/devices_list_screen.dart';
import 'package:paylash/screens/home_screen/home_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'search',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/devices',
      name: 'devices',
      builder: (context, state) => const DevicesListScreen(),
    ),
  ],
);
