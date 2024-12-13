import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rum_sdk/rum_flutter.dart';

final rumProvider = Provider((ref) => RumFlutter());

final tracerProvider = Provider((ref) {
  final faro = ref.watch(rumProvider);
  return faro.getTracer();
});
