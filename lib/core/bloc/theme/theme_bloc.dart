import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';
/*
|--------------------------------------------------------------------------
| bloc:
|--------------------------------------------------------------------------
*/

class ThemeBloc {
  static ThemeBloc of(BuildContext context) => AppProvider.of(context).theme;

  /*
  |--------------------------------------------------------------------------
  | stream controllers:
  |--------------------------------------------------------------------------
  */
  final _stateController = StreamController<ThemeState>.broadcast();

  final _eventController = StreamController<ThemeEvent>();

  /*
  |--------------------------------------------------------------------------
  | exposed stream
  |--------------------------------------------------------------------------
  */

  Stream<ThemeState> get stream => _stateController.stream;

  /*
  |--------------------------------------------------------------------------
  | internal state, default is first in list of available
  |--------------------------------------------------------------------------
  */

  AppTheme _appTheme = AVAILABLE_THEMES.entries.first.value;

  /*
  |--------------------------------------------------------------------------
  | global getters
  |--------------------------------------------------------------------------
  */

  static AppTheme _theme = AVAILABLE_THEMES.entries.first.value;
  static AppThemeMode _themeMode = DEFAULT_THEME_MODE;

  static String get getThemeTitle => _theme.themeTitle;
  static AppThemeMode get getThemeMode => _themeMode;
  static ThemeData get getThemeData => _theme.themeData;

  static ColorScheme get colorScheme => _theme.themeData.colorScheme;

  static AppPageInterface get pageInterface => _theme.pageInterface;
  static AppScreenInterface get screenInterface => _theme.screenInterface;
  static AppTextInterface get textInterface => _theme.textInterface;
  static AppWidgetInterface get widgetInterface => _theme.widgetInterface;
  static AppActionInterface get actionInterface => _theme.actionInterface;
  static AppObjectInterface get objectInterface => _theme.objectInterface;

  /*
  |--------------------------------------------------------------------------
  | constructor:
  |--------------------------------------------------------------------------
  */

  ThemeBloc() {
    AppLogger.blockInfo("ThemeBloc: Init");
    _eventController.stream.listen(_handleEvent);
  }

  /*
  |--------------------------------------------------------------------------
  | push events [exposed]:
  |--------------------------------------------------------------------------
  */

  void pushEvent(ThemeEvent event) {
    AppLogger.blockInfo("ThemeBloc [UI]: Event ~> ${event.runtimeType}");
    _eventController.sink.add(event);
  }

  /*
  |--------------------------------------------------------------------------
  | push state:
  |--------------------------------------------------------------------------
  */

  void _pushState(ThemeState state) {
    AppLogger.blockInfo("ThemeBloc: State ~> ${state.runtimeType}");

    // do internal state changes (if any)
    switch (state.runtimeType) {
      case ThemeStateThemeChanged:
        _appTheme = (state as ThemeStateThemeChanged).theme;
        _theme = _appTheme;
        _themeMode = _appTheme.themeMode;
        break;

      case ThemeStateThemeModeChanged:
        _appTheme.setAppThemeMode((state as ThemeStateThemeModeChanged).themeMode);
        _themeMode = _appTheme.themeMode;
        break;
    }

    // push the state to listeners
    _stateController.sink.add(state);
  }

  /*
  |--------------------------------------------------------------------------
  | handle events:
  |--------------------------------------------------------------------------
  */

  void _handleEvent(ThemeEvent event) {
    AppLogger.blockInfo("ThemeBloc: Handling event <~ ${event.runtimeType}");

    switch (event.runtimeType) {
      case ThemeEventSetFromLocalRepo:
        return _themeEventSetFromLocalRepo(event as ThemeEventSetFromLocalRepo);

      case ThemeEventChangeTheme:
        return _themeEventChangeTheme(event as ThemeEventChangeTheme);

      case ThemeEventChangeThemeMode:
        return _themeEventChangeThemeMode(event as ThemeEventChangeThemeMode);

      case ThemeEventToggleThemeMode:
        return _themeEventToggleThemeMode(event as ThemeEventToggleThemeMode);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | try setting theme from local repo:
  |--------------------------------------------------------------------------
  */

  void _themeEventSetFromLocalRepo(ThemeEventSetFromLocalRepo event) async {
    try {
      var themeTitle = await AppProvider.of(event.context).localRepo.getThemeTitle();
      var themeMode = await AppProvider.of(event.context).localRepo.getThemeMode();

      // if theme doesn't exists
      if (!AVAILABLE_THEMES.containsKey(themeTitle)) {
        // set default
        pushEvent(ThemeEventChangeTheme(event.context, AVAILABLE_THEMES.values.first));

        return;
      }

      // get theme instance
      var theme = AVAILABLE_THEMES[themeTitle];

      theme.setAppThemeMode(themeMode);

      // push to state
      _pushState(ThemeStateThemeChanged(event.context, theme));
    } catch (e) {
      AppLogger.exception(e);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | change theme:
  |--------------------------------------------------------------------------
  */

  void _themeEventChangeTheme(ThemeEventChangeTheme event) async {
    try {
      AppProvider.of(event.context).localRepo.saveThemeTitle(event.theme.themeTitle);
      AppProvider.of(event.context).localRepo.saveThemeMode(event.theme.themeMode);

      // retain theme mode
      event.theme.setAppThemeMode(_themeMode);

      _pushState(ThemeStateThemeChanged(event.context, event.theme));
    } catch (e) {
      AppLogger.exception(e);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | change theme mode
  |--------------------------------------------------------------------------
  */

  void _themeEventChangeThemeMode(ThemeEventChangeThemeMode event) async {
    try {
      print('CALL HEE');
      AppProvider.of(event.context).localRepo.saveThemeMode(event.theme.themeMode);

      _pushState(ThemeStateThemeChanged(event.context, event.theme));
    } catch (e) {
      AppLogger.exception(e);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | toggle theme mode
  |--------------------------------------------------------------------------
  */

  void _themeEventToggleThemeMode(ThemeEventToggleThemeMode event) async {
    try {
      var appThemeMode = event.themeMode == AppThemeMode.dark ? AppThemeMode.light : AppThemeMode.dark;

      AppProvider.of(event.context).localRepo.saveThemeMode(appThemeMode);

      _pushState(ThemeStateThemeModeChanged(event.context, appThemeMode));
    } catch (e) {
      AppLogger.exception(e);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | dispose streams [exposed]:
  |--------------------------------------------------------------------------
  */

  void dispose() {
    _eventController.close();
    _stateController.close();

    AppLogger.blockInfo("ThemeBloc: Dispose");
  }
}
