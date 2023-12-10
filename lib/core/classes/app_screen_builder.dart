import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';

class AppScreenBuilder extends InheritedWidget {
  final BuildContext context;

  AppScreenBuilder({
    required this.context,
    required Widget screen,
  }) : super(key: KeyGen.from(AppWidgetKey.appScreen), child: screen);

  static AppScreenBuilder of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<AppScreenBuilder>() as AppScreenBuilder;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
