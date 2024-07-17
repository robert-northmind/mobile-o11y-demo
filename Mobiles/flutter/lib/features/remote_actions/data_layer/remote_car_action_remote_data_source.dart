// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:flutter_mobile_o11y_demo/core/data_layer/http_client.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_door_status.dart';
import 'package:flutter_mobile_o11y_demo/features/remote_actions/data_layer/models/remote_car_door_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteCarActionRemoteDataSourceProvider = Provider((ref) {
  return RemoteCarActionRemoteDataSource(
    httpClient: ref.watch(httpClientProvider),
  );
});

class RemoteCarActionRemoteDataSource {
  RemoteCarActionRemoteDataSource({
    required HttpClient httpClient,
  }) : _httpClient = httpClient;

  final HttpClient _httpClient;

  Future<void> lockDoors() async {
    await _setDoorStatus(RemoteCarDoorStatus.locked);
  }

  Future<void> unlockDoors() async {
    await _setDoorStatus(RemoteCarDoorStatus.unlocked);
  }

  Future<CarDoorStatus> getDoorStatus() async {
    final response = await _httpClient.get('door-status');
    if (response.statusCode == 200) {
      final statusMap = json.decode(response.body);
      final remoteStatus = RemoteCarDoorStatus.fromJson(statusMap);
      return remoteStatus.toCarDoorStatus;
    } else {
      throw Exception(
        'Failed to get door status. Status code: ${response.statusCode}, body: ${response.body}',
      );
    }
  }

  Future<void> _setDoorStatus(RemoteCarDoorStatus status) async {
    final statusJson = json.encode(status);
    final response = await _httpClient.post('set-door-status', statusJson);
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to set door status. Status code: ${response.statusCode}, body: ${response.body}',
      );
    }
  }
}
