import 'package:go_router/go_router.dart';
import 'package:paylash/screens/home_screen/home_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'search',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
