import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/dialog_presenter.dart';

class ErrorPresenter {
  ErrorPresenter({
    required DialogPresenter dialogPresenter,
  }) : _dialogPresenter = dialogPresenter;

  final DialogPresenter _dialogPresenter;

  void presentError(Object error) {
    _dialogPresenter.presentDialog(
      (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('$error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
