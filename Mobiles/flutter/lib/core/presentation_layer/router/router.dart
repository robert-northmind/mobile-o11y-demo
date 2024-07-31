import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/pages/bottom_navigation_bar_scaffold.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/pages/car_actions_page.dart';
import 'package:flutter_mobile_o11y_demo/features/home/presentation_layer/pages/home_page.dart';
import 'package:flutter_mobile_o11y_demo/features/settings/presentation_layer/pages/settings_page.dart';
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
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: HomePage());
          },
        ),
        GoRoute(
          path: '/car-actions',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: CarActionsPage());
          },
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: SettingsPage());
          },
        ),
      ],
    )
  ],
);
