import 'package:equatable/equatable.dart';

class ConnectedToCarUiState extends Equatable {
  const ConnectedToCarUiState({
    required this.isLoading,
  });

  final bool isLoading;

  @override
  List<Object?> get props => [isLoading];
}
