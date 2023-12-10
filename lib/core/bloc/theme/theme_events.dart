import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';

abstract class ThemeEvent {
  final BuildContext context;

  ThemeEvent(this.context);
}

/// Try setting theme mode from local repo(if exists)
///
class ThemeEventSetFromLocalRepo extends ThemeEvent {
  ThemeEventSetFromLocalRepo(BuildContext context) : super(context);
}

/// Set theme type
///
class ThemeEventChangeTheme extends ThemeEvent {
  AppTheme theme;

  ThemeEventChangeTheme(BuildContext context, this.theme) : super(context);
}

/// Set theme type
///
class ThemeEventChangeThemeMode extends ThemeEvent {
  AppTheme theme;

  ThemeEventChangeThemeMode(BuildContext context, this.theme) : super(context);
}

/// Set theme type
///
class ThemeEventToggleThemeMode extends ThemeEvent {
  AppThemeMode themeMode;

  ThemeEventToggleThemeMode(BuildContext context, this.themeMode) : super(context);
}
