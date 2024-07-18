import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/home/presentation/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offline_transport/offline_transport.dart';
import 'package:rum_sdk/rum_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = RumHttpOverrides(HttpOverrides.current);
  await dotenv.load();

  final rumFlutter = RumFlutter();
  rumFlutter.transports.add(
    OfflineTransport(maxCacheDuration: const Duration(days: 3)),
  );

  rumFlutter.runApp(
    optionsConfiguration: RumConfig(
      appName: 'mobile-o11y-flutter-demo-app',
      appVersion: '1.0.0',
      appEnv: 'production',
      apiKey: dotenv.env['FARO_API_KEY'] ?? '',
      anrTracking: true,
      cpuUsageVitals: true,
      collectorUrl: dotenv.env['FARO_COLLECTOR_URL'] ?? '',
      enableCrashReporting: true,
      memoryUsageVitals: true,
      refreshRateVitals: true,
      fetchVitalsInterval: const Duration(seconds: 30),
    ),
    appRunner: () {
      runApp(
        DefaultAssetBundle(
          bundle: RumAssetBundle(),
          child: const RumUserInteractionWidget(
            child: ProviderScope(child: MyApp()),
          ),
        ),
      );
    },
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dialogPresenterProvider).setNavigatorKey(navigatorKey);

    return MaterialApp(
      title: 'MobileO11y Demo',
      navigatorObservers: [RumNavigationObserver()],
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
