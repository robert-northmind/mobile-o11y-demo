import 'package:equatable/equatable.dart';

class CarDoorStatus extends Equatable {
  const CarDoorStatus({required this.isLocked});

  final bool isLocked;

  @override
  List<Object?> get props => [isLocked];
}
