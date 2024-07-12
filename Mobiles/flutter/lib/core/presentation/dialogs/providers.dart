import 'package:flutter_mobile_o11y_demo/core/presentation/dialogs/dialog_presenter.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation/dialogs/error_presenter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
DialogPresenter dialogPresenter(
  DialogPresenterRef ref,
) {
  return DialogPresenter();
}

@riverpod
ErrorPresenter errorPresenter(
  ErrorPresenterRef ref,
) {
  return ErrorPresenter(
    dialogPresenter: ref.watch(dialogPresenterProvider),
  );
}
