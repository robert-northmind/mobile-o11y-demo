import 'package:flutter_mobile_o11y_demo/core/application_layer/selected_car/providers.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/selected_car/selected_car_service.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_door_status.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/error_presenter.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/remote_actions/data_layer/remote_car_action_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

final remoteCarActionServiceProvider = Provider.autoDispose((ref) {
  final service = RemoteCarActionService(
    remoteDataSource: ref.watch(remoteCarActionRemoteDataSourceProvider),
    errorPresenter: ref.watch(errorPresenterProvider),
    selectedCarService: ref.watch(selectedCarServiceProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

class RemoteCarActionService {
  RemoteCarActionService({
    required RemoteCarActionRemoteDataSource remoteDataSource,
    required ErrorPresenter errorPresenter,
    required SelectedCarService selectedCarService,
  })  : _remoteDataSource = remoteDataSource,
        _errorPresenter = errorPresenter,
        _selectedCarService = selectedCarService;

  final RemoteCarActionRemoteDataSource _remoteDataSource;
  final ErrorPresenter _errorPresenter;
  final SelectedCarService _selectedCarService;

  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;
  bool get isLoading => _isLoadingSubject.value;

  Future<void> lockDoors() async {
    _setDoorLockState(shouldLock: true);
  }

  Future<void> unlockDoors() async {
    _setDoorLockState(shouldLock: false);
  }

  Future<CarDoorStatus?> getDoorStatus() async {
    _isLoadingSubject.add(true);
    try {
      await _remoteDataSource.getDoorStatus();
    } catch (error) {
      _errorPresenter.presentError(
        'RemoteCarActionService getDoorStatus failed with error: $error',
      );
    }
    _isLoadingSubject.add(false);
    return null;
  }

  void dispose() {
    _isLoadingSubject.close();
  }

  Future<void> _setDoorLockState({required bool shouldLock}) async {
    final car = _selectedCarService.car;
    if (car == null) {
      // No car. Cannot do anything.
      return;
    }

    _isLoadingSubject.value = true;

    try {
      if (shouldLock) {
        await _remoteDataSource.lockDoors();
      } else {
        await _remoteDataSource.unlockDoors();
      }
      _updateCar(car: car, isLocked: shouldLock);
    } catch (error) {
      _errorPresenter.presentError(
        'RemoteCarActionService failed with error: $error',
      );
    }
    _isLoadingSubject.value = false;
  }

  Future<void> _updateCar({
    required Car car,
    required bool isLocked,
  }) async {
    final updatedCar = Car(
      info: car.info,
      doorStatus: CarDoorStatus(isLocked: isLocked),
    );
    _selectedCarService.updateSelectedCar(updatedCar);
  }
}
