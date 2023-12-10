import 'package:flutter/material.dart';

import 'package:photogram/theme/photogram/modes/pg_mode_implementation.dart';

class PgThemeModeDarkImplementation implements PgThemeModeImplementation {
  @override
  ThemeData get themeData => ThemeData.dark().copyWith(
        colorScheme: colorScheme,

        // extra colors
        cardColor: Colors.black,
        hintColor: Colors.grey[500],
        errorColor: Colors.red,
        focusColor: Colors.blue,
        hoverColor: Colors.grey,
        shadowColor: Colors.white,

        // divider colors
        dividerColor: Colors.grey[400],

        dividerTheme: DividerThemeData(color: Colors.grey.shade400, thickness: 0.8),

        // icon themes
        iconTheme: const IconThemeData(color: Colors.white),

        // secondary colors
        secondaryHeaderColor: Colors.blue[400],

        // highlight colors
        highlightColor: Colors.blue[400],
        toggleableActiveColor: Colors.blue[400],

        // app bar theme
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: normalBlackH2,
          actionsIconTheme: const IconThemeData(size: 25),
        ),

        // bottom nav
        bottomAppBarColor: Colors.black,

        // backgrounds
        dialogBackgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,

        // input theme
        inputDecorationTheme: const InputDecorationTheme(border: null),

        textTheme: getTextTheme,

        primaryTextTheme: getPrimaryTextTheme,
      );

  @override
  ColorScheme get colorScheme => ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.blue,
        primaryContainer: Colors.blue[700]!,
        onPrimary: Colors.white,
        secondary: Colors.grey[800]!,
        secondaryContainer: Colors.grey[900]!,
        onSecondary: Colors.white,
        surface: Colors.black,
        onSurface: Colors.white,
        background: Colors.black,
        onBackground: Colors.white,
        error: const Color(0xffb00020),
        onError: Colors.white,
      );

  // text styles

  @override
  get boldBlackH1 => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 19, color: Colors.white);
  @override
  get boldBlackH2 => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 17, color: Colors.white);
  @override
  get boldBlackH3 => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 16, color: Colors.white);
  @override
  get boldBlackH4 => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 15, color: Colors.white);
  @override
  get boldBlackH5 => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 14, color: Colors.white);
  @override
  get boldBlackH6 => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 13, color: Colors.white);
  @override
  get normalBlackH1 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 19, color: Colors.white);
  @override
  get normalBlackH2 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 17, color: Colors.white);
  @override
  get normalBlackH3 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white);
  @override
  get normalBlackH4 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 15, color: Colors.white);
  @override
  get normalBlackH5 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white);
  @override
  get normalBlackH6 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 13, color: Colors.white);
  @override
  get normalGreyH1 => TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 19, color: Colors.grey[300]);
  @override
  get normalGreyH2 => TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 17, color: Colors.grey[300]);
  @override
  get normalGreyH3 => TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 16, color: Colors.grey[300]);
  @override
  get normalGreyH4 => TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 15, color: Colors.grey[300]);
  @override
  get normalGreyH5 => TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 14, color: Colors.grey[300]);
  @override
  get normalGreyH6 => TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 13, color: Colors.grey[300]);
  @override
  get normalHrefH1 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 19, color: Colors.blue);
  @override
  get normalHrefH2 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 17, color: Colors.blue);
  @override
  get normalHrefH3 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 16, color: Colors.blue);
  @override
  get normalHrefH4 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 15, color: Colors.blue);
  @override
  get normalHrefH5 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 14, color: Colors.blue);
  @override
  get normalHrefH6 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 13, color: Colors.blue);
  @override
  get normalThemeH1 =>
      TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 19, color: colorScheme.primary);
  @override
  get normalThemeH2 =>
      TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 17, color: colorScheme.primary);
  @override
  get normalThemeH3 =>
      TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 16, color: colorScheme.primary);
  @override
  get normalThemeH4 =>
      TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 15, color: colorScheme.primary);
  @override
  get normalThemeH5 =>
      TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 14, color: colorScheme.primary);
  @override
  get normalThemeH6 =>
      TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 13, color: colorScheme.primary);

  @override
  get hollowButtonFontStyle => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.8, color: Colors.white);

  @override
  get themeButtonFontStyle => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.8, color: Colors.white);

  TextTheme get getTextTheme => ThemeData.dark().textTheme.copyWith(
        headline1: normalBlackH1,
        headline2: normalBlackH2,
        headline3: normalBlackH3,
        headline4: normalBlackH4,
        headline5: normalBlackH5,
        headline6: normalBlackH6,
        bodyText1: normalBlackH4,
        bodyText2: normalBlackH5,
        subtitle1: normalBlackH4,
        subtitle2: normalBlackH5,
        caption: normalGreyH4,
      );

  TextTheme get getPrimaryTextTheme => ThemeData.dark().textTheme.copyWith(
        headline1: normalThemeH1,
        headline2: normalThemeH2,
        headline3: normalThemeH3,
        headline4: normalThemeH4,
        headline5: normalThemeH5,
        headline6: normalThemeH6,
        bodyText1: normalThemeH4,
        bodyText2: normalThemeH5,
        subtitle1: normalThemeH4,
        subtitle2: normalThemeH5,
        caption: normalGreyH4,
      );
}
