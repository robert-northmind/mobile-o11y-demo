import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/current_user/current_user_service.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/selected_car/providers.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_model.dart';
import 'package:flutter_mobile_o11y_demo/features/home/presentation_layer/widgets/logged_in_home_widget.dart';
import 'package:flutter_mobile_o11y_demo/features/home/presentation_layer/widgets/not_logged_in_home_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeUiState = ref.watch(homeUiStateProvider);

    if (homeUiState is LoggedInHomeUiState) {
      return LoggedInHomeWidget(homeUiState: homeUiState);
    }
    return const NotLoggedInHomeWidget();
  }
}

abstract class HomeUiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotLoggedInHomeUiState extends HomeUiState {}

class LoggedInHomeUiState extends HomeUiState {
  LoggedInHomeUiState({
    required this.username,
    required this.carInfo,
    required this.carImagePath,
  });

  final String username;
  final String carInfo;
  final String carImagePath;

  @override
  List<Object?> get props => [username, carInfo];
}

final homeUiStateProvider = Provider.autoDispose<HomeUiState>((ref) {
  final userService = ref.watch(currentUserServiceProvider);

  final currentUser = userService.user;
  if (currentUser == null) {
    return NotLoggedInHomeUiState();
  }

  final car = ref.watch(selectedCarProvider);
  var carInfo = '';
  var carImagePath = '';
  if (car != null) {
    carInfo = '''
This is your car:
vin: ${car.info.vin}
model: ${car.info.model}
''';

    carImagePath = car.info.model.imageAssetPath;
  }

  return LoggedInHomeUiState(
    username: currentUser.username,
    carInfo: carInfo,
    carImagePath: carImagePath,
  );
});
