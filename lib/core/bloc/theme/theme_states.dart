import 'package:flutter/widgets.dart';
import 'package:photogram/import/core.dart';

abstract class ThemeState {
  final BuildContext context;

  ThemeState(this.context);
}

/// Theme changed
///
class ThemeStateThemeChanged extends ThemeState {
  AppTheme theme;

  ThemeStateThemeChanged(BuildContext context, this.theme) : super(context);
}

/// Theme mode changed
///
class ThemeStateThemeModeChanged extends ThemeState {
  AppThemeMode themeMode;

  ThemeStateThemeModeChanged(BuildContext context, this.themeMode) : super(context);
}
