import 'package:equatable/equatable.dart';

class NotConnectedToCarUiState extends Equatable {
  const NotConnectedToCarUiState({
    required this.isLoading,
  });

  final bool isLoading;

  @override
  List<Object?> get props => [isLoading];
}
