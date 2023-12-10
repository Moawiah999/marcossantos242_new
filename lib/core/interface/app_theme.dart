import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';

abstract class AppTheme {
  String get themeTitle;
  ThemeData get themeData;
  AppThemeMode get themeMode;

  AppTextInterface get textInterface;
  AppPageInterface get pageInterface;
  AppWidgetInterface get widgetInterface;
  AppActionInterface get actionInterface;
  AppObjectInterface get objectInterface;
  AppScreenInterface get screenInterface;

  void setAppThemeMode(AppThemeMode appThemeMode);
}
