import 'package:equatable/equatable.dart';

class PhoneToCarLockUnlockActionUiState extends Equatable {
  const PhoneToCarLockUnlockActionUiState({
    required this.actionButtonTitle,
    required this.isLoading,
    required this.isLocked,
  });

  final String actionButtonTitle;
  final bool isLoading;
  final bool isLocked;

  @override
  List<Object?> get props => [actionButtonTitle, isLoading, isLocked];
}
