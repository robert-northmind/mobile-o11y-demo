import 'package:equatable/equatable.dart';

class PhoneToCarActionsUiState extends Equatable {
  const PhoneToCarActionsUiState({
    required this.isConnected,
  });

  final bool isConnected;

  @override
  List<Object?> get props => [isConnected];
}
