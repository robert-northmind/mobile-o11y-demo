import 'package:faro/faro_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/pages/bottom_navigation_bar_scaffold.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/pages/car_actions_page.dart';
import 'package:flutter_mobile_o11y_demo/features/home/presentation_layer/pages/home_page.dart';
import 'package:flutter_mobile_o11y_demo/features/settings/presentation_layer/pages/settings_page.dart';
import 'package:go_router/go_router.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/home',
  // observers: [FaroNavigationObserver()],
  routes: [
    ShellRoute(
      // observers: [FaroNavigationObserver()],
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) =>
          BottomNavigationBarScaffold(child: child),
      routes: [
        GoRoute(
          name: 'home',
          path: '/home',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              name: state.name,
              child: const HomePage(),
            );
          },
        ),
        GoRoute(
          name: 'car-actions',
          path: '/car-actions',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              name: state.name,
              child: const CarActionsPage(),
            );
          },
        ),
        GoRoute(
          name: 'settings',
          path: '/settings',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              name: state.name,
              child: const SettingsPage(),
            );
          },
        ),
      ],
    )
  ],
);
