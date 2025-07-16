// ignore_for_file: cascade_invocations, lines_longer_than_80_chars

import 'package:faro/faro.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/loggers/o11y_logger.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/traces/o11y_traces.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/selected_car/providers.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/selected_car/selected_car_service.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_door_status.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/error_presenter.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/remote_actions/data_layer/remote_car_action_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

final remoteCarActionServiceProvider = Provider.autoDispose((ref) {
  final service = RemoteCarActionService(
    remoteDataSource: ref.watch(remoteCarActionRemoteDataSourceProvider),
    errorPresenter: ref.watch(errorPresenterProvider),
    selectedCarService: ref.watch(selectedCarServiceProvider),
    traces: ref.watch(o11yTracesProvider),
    logger: ref.watch(o11yLoggerProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

class RemoteCarActionService {
  RemoteCarActionService({
    required RemoteCarActionRemoteDataSource remoteDataSource,
    required ErrorPresenter errorPresenter,
    required SelectedCarService selectedCarService,
    required O11yTraces traces,
    required O11yLogger logger,
  })  : _remoteDataSource = remoteDataSource,
        _errorPresenter = errorPresenter,
        _selectedCarService = selectedCarService,
        _traces = traces,
        _logger = logger;

  final RemoteCarActionRemoteDataSource _remoteDataSource;
  final ErrorPresenter _errorPresenter;
  final SelectedCarService _selectedCarService;
  final O11yTraces _traces;
  final O11yLogger _logger;

  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;
  bool get isLoading => _isLoadingSubject.value;

  // Add a helper method to safely set loading state
  void _setLoading(bool value) {
    if (!_isLoadingSubject.isClosed) {
      _isLoadingSubject.value = value;
    }
  }

  void dispose() {
    _isLoadingSubject.close();
  }

  Future<void> lockDoors() async {
    _logger.debug('Starting Locking doors', context: {
      'service': 'RemoteCarActionService',
    });
    await _setDoorLockState(shouldLock: true);
    _logger.debug('Completed Locking doors', context: {
      'service': 'RemoteCarActionService',
    });
  }

  Future<void> unlockDoors() async {
    _logger.debug('Starting Unlocking doors', context: {
      'service': 'RemoteCarActionService',
    });
    await _setDoorLockState(shouldLock: false);
    _logger.debug('Completed Unlocking doors', context: {
      'service': 'RemoteCarActionService',
    });
  }

  Future<void> _setDoorLockState({required bool shouldLock}) async {
    final car = _selectedCarService.car;
    if (car == null) {
      // No car. Cannot do anything.
      return;
    }
    await _traces.startSpan(
      'Remote-SetDoorStatus',
      (span) async {
        _setLoading(true);
        try {
          await _setDoorLockStateInternal(shouldLock: shouldLock, car: car);
          span.addEvent('Successfully set door lock state', attributes: {
            'shouldLock': shouldLock.toString(),
          });
          span.setStatus(SpanStatusCode.ok);
        } catch (error) {
          _errorPresenter.presentError(
            'RemoteCarActionService failed with error: $error',
          );
          span.addEvent('Failed to set door lock state', attributes: {
            'shouldLock': shouldLock.toString(),
          });
          span.setStatus(
            SpanStatusCode.error,
            message:
                'Failed to set door lock state to ${shouldLock ? 'Locked' : 'Unlocked'}',
          );
        }
        _setLoading(false);
      },
    );
  }

  Future<void> _setDoorLockStateInternal({
    required Car car,
    required bool shouldLock,
  }) async {
    if (shouldLock) {
      await _remoteDataSource.lockDoors();
    } else {
      await _remoteDataSource.unlockDoors();
    }

    await _pollForDoorStatusChange(expectedLockState: shouldLock);

    _updateCar(car: car, isLocked: shouldLock);
  }

  Future<void> _pollForDoorStatusChange({
    required bool expectedLockState,
  }) async {
    const maxAttempts = 6;
    const pollInterval = Duration(seconds: 3);

    var didComplete = false;
    var numberAttempts = 0;

    while (didComplete == false && numberAttempts < maxAttempts) {
      await _traces.startSpan('Remote-CheckDoorStatusPoller', (span) async {
        try {
          final doorStatus = await _remoteDataSource.getDoorStatus();
          if (doorStatus.isLocked == expectedLockState) {
            span.setStatus(SpanStatusCode.ok,
                message: 'Door status got updated!');
            didComplete = true;
          } else {
            span.setStatus(
              SpanStatusCode.unset,
              message: 'Door status did not update yet',
            );
          }
        } catch (error) {
          print('_pollForDoorStatusChange failed with error: $error');
          span.setStatus(
            SpanStatusCode.error,
            message: 'Door status check failed with error: $error',
          );
        }

        numberAttempts += 1;
        if (didComplete == false && numberAttempts < maxAttempts) {
          await Future.delayed(pollInterval);
        }
      });
    }

    if (didComplete == false) {
      throw Exception('Door status did not change as expected.');
    }
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
