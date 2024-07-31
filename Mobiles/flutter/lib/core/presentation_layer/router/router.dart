import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/pages/bottom_navigation_bar_scaffold.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/pages/car_actions_page.dart';
import 'package:go_router/go_router.dart';
import 'package:rum_sdk/rum_sdk.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/home',
  observers: [RumNavigationObserver()],
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) =>
          BottomNavigationBarScaffold(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage2(),
        ),
        GoRoute(
          path: '/car-actions',
          builder: (context, state) => const CarActionsPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    )
  ],
);

class HomePage2 extends StatelessWidget {
  const HomePage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobileO11y Demo'),
      ),
      body: const Center(
        child: Center(
          child: Text('Hi'),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobileO11y Demo'),
      ),
      body: const Center(
        child: Center(
          child: Text('Settings'),
        ),
      ),
    );
  }
}
