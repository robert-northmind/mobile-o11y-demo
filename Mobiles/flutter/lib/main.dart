// ignore_for_file: avoid_redundant_argument_values

import 'dart:io';

import 'package:faro/faro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/providers.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/router/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  HttpOverrides.global = FaroHttpOverrides(HttpOverrides.current);

  Faro().transports.add(
        OfflineTransport(
          maxCacheDuration: const Duration(days: 3),
        ),
      );

  Faro().runApp(
    optionsConfiguration: FaroConfig(
      appName: 'mobile-o11y-flutter-demo-app',
      appVersion: '1.0.0',
      appEnv: 'production',
      apiKey: dotenv.env['FARO_API_KEY']!,
      collectorUrl: dotenv.env['FARO_COLLECTOR_URL'],
      cpuUsageVitals: true,
      memoryUsageVitals: true,
      anrTracking: true,
      refreshRateVitals: true,
      fetchVitalsInterval: const Duration(seconds: 30),
      enableCrashReporting: true,
    ),
    appRunner: () {
      runApp(DefaultAssetBundle(
        bundle: FaroAssetBundle(),
        child: const FaroUserInteractionWidget(
          child: ProviderScope(child: MyApp()),
        ),
      ));
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dialogPresenterProvider).setNavigatorKey(navigatorKey);

    return MaterialApp.router(
      title: 'MobileO11y Demo',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
