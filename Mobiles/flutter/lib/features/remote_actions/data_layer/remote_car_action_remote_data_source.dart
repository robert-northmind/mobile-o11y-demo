import 'package:flutter_mobile_o11y_demo/core/data_layer/http_client.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_door_status.dart';
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
    await _httpClient.get('door-status');
  }

  Future<void> unlockDoors() async {
    await _httpClient.get('door-status');
  }

  Future<CarDoorStatus?> getDoorStatus() async {
    await _httpClient.get('door-status');
    return null;
  }
}
