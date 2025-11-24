import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/widgets/car_lock_unlock_action_widget.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/remote_actions/application_layer/remote_car_action_service.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/remote_actions/domain/error_simulation_type.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/remote_actions/presentation/ui_states/remote_actions_page_ui_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoteActionsPage extends ConsumerWidget {
  const RemoteActionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(remoteActionsPageUiStateProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Here you can control your car from anywhere in the world!',
              textAlign: TextAlign.center,
            ),
            const Divider(),
            const SizedBox(height: 16),
            CarLockUnlockActionWidget(
              isLoading: uiState.isLoading,
              isLocked: uiState.isLocked,
              onPressed: () {
                if (uiState.isLocked) {
                  ref.read(remoteCarActionServiceProvider).unlockDoors();
                } else {
                  ref.read(remoteCarActionServiceProvider).lockDoors();
                }
              },
            ),
            const SizedBox(height: 24),
            _ErrorSimulationDropdown(
              selectedErrorType: uiState.errorSimulationType,
              onChanged: (errorType) {
                if (errorType != null) {
                  ref
                      .read(remoteCarActionServiceProvider)
                      .setErrorSimulationType(errorType);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorSimulationDropdown extends StatelessWidget {
  const _ErrorSimulationDropdown({
    required this.selectedErrorType,
    required this.onChanged,
  });

  final ErrorSimulationType selectedErrorType;
  final ValueChanged<ErrorSimulationType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bug_report, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Error Simulation',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ErrorSimulationType>(
              value: selectedErrorType,
              decoration: const InputDecoration(
                labelText: 'Error Type',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: ErrorSimulationType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
