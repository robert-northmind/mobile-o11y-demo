import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/dialog_presenter.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/error_presenter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
DialogPresenter dialogPresenter(
  DialogPresenterRef ref,
) {
  return DialogPresenter();
}

@Riverpod(keepAlive: true)
ErrorPresenter errorPresenter(
  ErrorPresenterRef ref,
) {
  return ErrorPresenter(
    dialogPresenter: ref.watch(dialogPresenterProvider),
  );
}
