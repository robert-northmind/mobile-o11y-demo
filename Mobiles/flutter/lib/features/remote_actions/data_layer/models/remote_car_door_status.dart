import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_door_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remote_car_door_status.g.dart';

@JsonSerializable()
class RemoteCarDoorStatus {
  RemoteCarDoorStatus({
    required this.status,
  });

  factory RemoteCarDoorStatus.fromJson(Map<String, dynamic> json) =>
      _$RemoteCarDoorStatusFromJson(json);

  static RemoteCarDoorStatus locked = RemoteCarDoorStatus(status: 'locked');
  static RemoteCarDoorStatus unlocked = RemoteCarDoorStatus(status: 'unlocked');

  final String status;

  Map<String, dynamic> toJson() => _$RemoteCarDoorStatusToJson(this);
}

extension RemoteCarDoorStatusX on RemoteCarDoorStatus {
  CarDoorStatus get toCarDoorStatus =>
      CarDoorStatus(isLocked: status == 'locked');
}
