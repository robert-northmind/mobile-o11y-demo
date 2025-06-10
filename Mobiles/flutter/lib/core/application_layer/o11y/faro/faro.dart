import 'package:faro/faro.dart';
import 'package:faro/faro_sdk.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/local_o11y/local_tracer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final faroProvider = Provider((ref) => Faro());

final tracerProvider = Provider((ref) {
  return LocalTracer();

  // final faro = ref.watch(faroProvider);
  // return faro.getTracer();
});
