import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/pg_driver.dart';
import 'package:photogram/theme/photogram/modes/pg_mode_implementation.dart';
import 'package:photogram/theme/photogram/modes/pg_theme_mode_light_implementation.dart';
import 'package:photogram/theme/photogram/modes/pg_theme_mode_dark_implementation.dart';

class PhotogramTheme implements AppTheme {
  /*
  |--------------------------------------------------------------------------
  | theme interface:
  |--------------------------------------------------------------------------
  */

  static String get title => APP_NAME;

  @override
  String get themeTitle => title;
  @override
  ThemeData get themeData => modeImplementation.themeData;
  @override
  AppThemeMode get themeMode => _mode;

  @override
  void setAppThemeMode(AppThemeMode themeMode) => _mode = themeMode;

  /*
  |--------------------------------------------------------------------------
  | interfaces:
  |--------------------------------------------------------------------------
  */

  @override
  AppActionInterface get actionInterface => _appActionInterface;

  @override
  AppObjectInterface get objectInterface => _appObjectInterface;

  @override
  AppPageInterface get pageInterface => _appPageInterface;

  @override
  AppTextInterface get textInterface => _appTextInterface;

  @override
  AppScreenInterface get screenInterface => _appScreenInterface;

  @override
  AppWidgetInterface get widgetInterface => _appWidgetInterface;

  /*
  |--------------------------------------------------------------------------
  | internal data:
  |--------------------------------------------------------------------------
  */

  AppThemeMode _mode = DEFAULT_THEME_MODE;

  PgThemeModeImplementation? darkImplementation;
  PgThemeModeImplementation? lightImplementation;

  late final AppPageInterface _appPageInterface;
  late final AppTextInterface _appTextInterface;
  late final AppWidgetInterface _appWidgetInterface;
  late final AppActionInterface _appActionInterface;
  late final AppObjectInterface _appObjectInterface;
  late final AppScreenInterface _appScreenInterface;

  /*
  |--------------------------------------------------------------------------
  | Constructor:
  |--------------------------------------------------------------------------
  */

  PhotogramTheme() {
    PgDriver driver = PgDriver(this);

    _appPageInterface = driver.implementPageInterface();
    _appTextInterface = driver.implementTextInterface();
    _appScreenInterface = driver.implementScreenInterface();
    _appWidgetInterface = driver.implementWidgetInterface();
    _appActionInterface = driver.implementActionInterface();
    _appObjectInterface = driver.implementObjectInterface();
  }

  /*
  |--------------------------------------------------------------------------
  | functions:
  |--------------------------------------------------------------------------
  */

  PgThemeModeImplementation get modeImplementation {
    if (_mode == AppThemeMode.dark) {
      darkImplementation ??= PgThemeModeDarkImplementation();

      return darkImplementation!;
    }

    lightImplementation ??= PgThemeModeLightImplementation();

    return lightImplementation!;
  }
}
