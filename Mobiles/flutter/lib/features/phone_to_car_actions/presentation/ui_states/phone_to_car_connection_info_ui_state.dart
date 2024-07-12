import 'package:equatable/equatable.dart';

class PhoneToCarConnectionInfoUiState extends Equatable {
  const PhoneToCarConnectionInfoUiState({
    required this.connectedToName,
    required this.connectedToVin,
  });

  final String connectedToName;
  final String connectedToVin;

  @override
  List<Object?> get props => [connectedToName, connectedToVin];
}
