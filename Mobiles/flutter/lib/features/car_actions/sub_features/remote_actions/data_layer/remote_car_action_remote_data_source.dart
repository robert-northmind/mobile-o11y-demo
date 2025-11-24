// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/loggers/o11y_logger.dart';
import 'package:flutter_mobile_o11y_demo/core/data_layer/http_client.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_door_status.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/remote_actions/data_layer/models/remote_car_door_status.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/remote_actions/domain/error_simulation_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteCarActionRemoteDataSourceProvider = Provider((ref) {
  return RemoteCarActionRemoteDataSource(
    httpClient: ref.watch(httpClientProvider),
    logger: ref.watch(o11yLoggerProvider),
  );
});

class RemoteCarActionRemoteDataSource {
  RemoteCarActionRemoteDataSource({
    required HttpClient httpClient,
    required O11yLogger logger,
  })  : _httpClient = httpClient,
        _logger = logger;

  final HttpClient _httpClient;
  final O11yLogger _logger;

  Future<void> lockDoors({
    ErrorSimulationType errorType = ErrorSimulationType.random,
  }) async {
    await _setDoorStatus(RemoteCarDoorStatus.locked, errorType: errorType);
  }

  Future<void> unlockDoors({
    ErrorSimulationType errorType = ErrorSimulationType.random,
  }) async {
    await _setDoorStatus(RemoteCarDoorStatus.unlocked, errorType: errorType);
  }

  Future<CarDoorStatus> getDoorStatus({
    ErrorSimulationType errorType = ErrorSimulationType.random,
  }) async {
    final headers = _buildErrorSimulationHeaders(errorType);
    final response = await _httpClient.get('door-status', headers: headers);
    if (response.statusCode == 200) {
      final statusMap = json.decode(response.body);
      final remoteStatus = RemoteCarDoorStatus.fromJson(statusMap);
      return remoteStatus.toCarDoorStatus;
    } else {
      final exception = Exception(
        'Failed to get door status. Status code: ${response.statusCode}, body: ${response.body}',
      );
      _logger.error('GetDoorStatus Error', error: exception);
      throw exception;
    }
  }

  Future<void> _setDoorStatus(
    RemoteCarDoorStatus status, {
    required ErrorSimulationType errorType,
  }) async {
    final statusJson = json.encode(status);
    final headers = _buildErrorSimulationHeaders(errorType);
    final response =
        await _httpClient.post('set-door-status', statusJson, headers: headers);
    if (response.statusCode != 200) {
      final exception = Exception(
        'Failed to set door status. Status code: ${response.statusCode}, body: ${response.body}',
      );
      _logger.error('SetDoorStatus Error', error: exception);
      throw exception;
    }
  }

  Map<String, String> _buildErrorSimulationHeaders(
    ErrorSimulationType errorType,
  ) {
    return {
      'X-Debug-Error-Type': errorType.toHeaderValue(),
    };
  }
}
