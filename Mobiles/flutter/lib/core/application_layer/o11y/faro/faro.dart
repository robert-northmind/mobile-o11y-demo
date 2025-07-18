import 'package:faro/faro.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/faro/fake_faro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final faroProvider = Provider<Faro>((ref) {
  return FakeFaro();

  // return Faro();
});
