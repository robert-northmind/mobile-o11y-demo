import 'package:faro/faro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rumProvider = Provider((ref) => Faro());

final tracerProvider = Provider((ref) {
  final faro = ref.watch(rumProvider);
  return faro.getTracer();
});
