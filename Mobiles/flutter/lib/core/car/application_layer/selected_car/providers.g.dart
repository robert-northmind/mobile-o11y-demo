// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedCarServiceHash() =>
    r'f9b980a0afbf96c5556fe6afcb1c832f6bffa368';

/// See also [selectedCarService].
@ProviderFor(selectedCarService)
final selectedCarServiceProvider = Provider<SelectedCarService>.internal(
  selectedCarService,
  name: r'selectedCarServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCarServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SelectedCarServiceRef = ProviderRef<SelectedCarService>;
String _$selectedCarHash() => r'd151d9b4eb2675d94c0ff95ecc2f29c7ae2adb98';

/// See also [selectedCar].
@ProviderFor(selectedCar)
final selectedCarProvider = AutoDisposeProvider<Car?>.internal(
  selectedCar,
  name: r'selectedCarProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedCarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SelectedCarRef = AutoDisposeProviderRef<Car?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
