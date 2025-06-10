import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/events/o11y_events.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/loggers/o11y_logger.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/metrics/o11y_metrics.dart';
import 'package:flutter_mobile_o11y_demo/core/data_layer/http_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final o11yEvents = ref.watch(o11yEventsProvider);
    final o11yLogger = ref.watch(o11yLoggerProvider);
    final httpClient = ref.watch(httpClientProvider);
    final o11yMetrics = ref.watch(o11yMetricsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final json = jsonEncode({'title': 'This is a title'});
                  final response = await httpClient.post('failpost', json);
                  o11yLogger.debug('Got response from failpost', context: {
                    'response_code': '${response.statusCode}',
                  });
                },
                child: const Text('HTTP POST Request - fail'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final json = jsonEncode({'title': 'This is a title'});
                  final response = await httpClient.post('successpost', json);
                  o11yLogger.debug('Got response from successpost', context: {
                    'response_code': '${response.statusCode}',
                  });
                },
                child: const Text('HTTP POST Request - success'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final response = await httpClient.get('failget');
                  o11yLogger.debug('Got response from failget', context: {
                    'response_code': '${response.statusCode}',
                  });
                },
                child: const Text('HTTP GET Request - fail'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final response = await httpClient.get('successget');
                  o11yLogger.debug('Got response from successget', context: {
                    'response_code': '${response.statusCode}',
                  });
                },
                child: const Text('HTTP GET Request - success'),
              ),
              ElevatedButton(
                onPressed: () {
                  o11yLogger.debug(
                    'Custom debug Log triggered from button',
                    context: {'custom_key': 'custom_value'},
                  );
                },
                child: const Text('Custom Debug Log'),
              ),
              ElevatedButton(
                onPressed: () {
                  o11yLogger.warning(
                    'Custom Warning Log triggered from button',
                    context: {'custom_key': 'custom_value'},
                  );
                },
                child: const Text('Custom Warn Log'),
              ),
              ElevatedButton(
                onPressed: () {
                  o11yMetrics.addMeasurement(
                    'custom_measurement',
                    {'custom_value': 1},
                  );
                },
                child: const Text('Custom Measurement'),
              ),
              ElevatedButton(
                onPressed: () {
                  o11yEvents.trackEvent('a_custom_event_triggered_from_button');
                },
                child: const Text('Send Event'),
              ),
              ElevatedButton(
                onPressed: () async {
                  o11yEvents.trackStartEvent(
                    'some_event_key',
                    'some_event_name',
                  );
                },
                child: const Text('Mark Event Start'),
              ),
              ElevatedButton(
                onPressed: () async {
                  o11yEvents.trackEndEvent(
                    'some_event_key',
                    'some_event_name',
                    attributes: {
                      'some_attribute_1': 'some_value_1',
                      'some_attribute_2': 'some_value_2',
                    },
                  );
                },
                child: const Text('Mark Event End'),
              ),
              ElevatedButton(
                onPressed: () async {
                  throw CustomError('Throwing an error from example button');
                },
                child: const Text('Throw Error'),
              ),
              ElevatedButton(
                onPressed: () async {
                  throw Exception('Throwing an exception from example button');
                },
                child: const Text('Throw Exception'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomError extends Error {
  CustomError(this.message);

  final String message;

  @override
  String toString() {
    return 'CustomError: $message';
  }
}
