// ignore_for_file: use_setters_to_change_properties

import 'package:flutter/material.dart';

class DialogPresenter {
  GlobalKey? _navigatorKey;

  void setNavigatorKey(GlobalKey key) {
    _navigatorKey = key;
  }

  void presentDialog(
    WidgetBuilder builder,
  ) {
    final navigatorKey = _navigatorKey;
    if (navigatorKey == null) {
      return;
    }

    showDialog(
      context: navigatorKey.currentContext!,
      builder: builder,
    );
  }
}
