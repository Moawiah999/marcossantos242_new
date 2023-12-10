import 'package:flutter/material.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';

class PgThemePage extends ThemePage {
  const PgThemePage({Key? key}) : super(key: key);

  @override
  State<PgThemePage> createState() => _PgThemePageState();
}

class _PgThemePageState extends State<PgThemePage> with AppUtilsMixin {
  var _activeThemeTitle = ThemeBloc.getThemeTitle;

  @override
  Widget build(BuildContext context) {
    _activeThemeTitle = ThemeBloc.getThemeTitle;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(AppLocalizations.of(context)!.theme),
        leading: GestureDetector(
          onTap: AppNavigation.pop,
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.builder(
        itemCount: AVAILABLE_THEMES.length,
        itemBuilder: (context, index) {
          return RadioListTile<String>(
            title: Text(
              AVAILABLE_THEMES.keys.elementAt(index),
              style: Theme.of(context).textTheme.subtitle2,
            ),
            value: AVAILABLE_THEMES.keys.elementAt(index),
            groupValue: _activeThemeTitle,
            onChanged: (String? value) => _updateTheme(value),
          );
        },
      ),
    );
  }

  void _updateTheme(String? themeToSet) {
    if (null == themeToSet || !AVAILABLE_THEMES.containsKey(themeToSet)) return;

    var appTheme = AVAILABLE_THEMES[themeToSet];

    appTheme.setAppThemeMode(ThemeBloc.getThemeMode);

    ThemeBloc.of(context).pushEvent(ThemeEventChangeTheme(context, appTheme));

    utilMixinSetState(() {
      _activeThemeTitle = themeToSet;
    });
  }
}
