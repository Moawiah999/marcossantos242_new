import 'package:flutter/material.dart';

import 'package:photogram/theme/photogram/modes/pg_mode_implementation.dart';

class PgThemeModeLightImplementation extends PgThemeModeImplementation {
  @override
  ThemeData get themeData => ThemeData.light().copyWith(
        colorScheme: colorScheme,

        // extra colors
        cardColor: Colors.white,
        hintColor: Colors.grey[500],
        errorColor: Colors.red,
        focusColor: Colors.blue,
        hoverColor: Colors.grey,

        // divider colors
        dividerColor: Colors.grey[400],
        dividerTheme: DividerThemeData(color: Colors.grey.shade400, thickness: 0.6),

        // icon themes
        iconTheme: const IconThemeData(color: Colors.black, size: 30),

        // secondary colors
        secondaryHeaderColor: Colors.blue[400],

        // highlight colors
        highlightColor: Colors.blue[400],
        toggleableActiveColor: Colors.blue[400],

        // app bar theme
        appBarTheme: AppBarTheme(
          elevation: 1,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: normalBlackH2,
          actionsIconTheme: const IconThemeData(size: 25),
        ),
        bottomAppBarColor: Colors.white,

        // backgrounds
        dialogBackgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,

        // input theme
        inputDecorationTheme: const InputDecorationTheme(
          border: null,
        ),

        textTheme: getTextTheme,

        primaryTextTheme: getPrimaryTextTheme,
      );

  @override
  ColorScheme get colorScheme => ColorScheme(
        brightness: Brightness.light,
        primary: Colors.blue,
        primaryContainer: Colors.blue[700]!,
        onPrimary: Colors.white,
        secondary: Colors.blue[100]!,
        secondaryContainer: Colors.blue[200]!,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        background: Colors.white,
        onBackground: Colors.black,
        error: const Color(0xffb00020),
        onError: Colors.white,
      );

  // text styles

  @override
  get boldBlackH1 => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 19, color: Colors.black);
  @override
  get boldBlackH2 => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 17, color: Colors.black);
  @override
  get boldBlackH3 => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 16, color: Colors.black);
  @override
  get boldBlackH4 => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 15, color: Colors.black);
  @override
  get boldBlackH5 => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 14, color: Colors.black);
  @override
  get boldBlackH6 => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, letterSpacing: 0.6, fontSize: 13, color: Colors.black);
  @override
  get normalBlackH1 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 19, color: Colors.black);
  @override
  get normalBlackH2 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 17, color: Colors.black);
  @override
  get normalBlackH3 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 16, color: Colors.black);
  @override
  get normalBlackH4 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black);
  @override
  get normalBlackH5 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 14, color: Colors.black);
  @override
  get normalBlackH6 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 13, color: Colors.black);
  @override
  get normalGreyH1 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 19, color: Colors.grey);
  @override
  get normalGreyH2 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 17, color: Colors.grey);
  @override
  get normalGreyH3 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 16, color: Colors.grey);
  @override
  get normalGreyH4 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 15, color: Colors.grey);
  @override
  get normalGreyH5 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 14, color: Colors.grey);
  @override
  get normalGreyH6 =>
      const TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 13, color: Colors.grey);
  @override
  get normalHrefH1 =>
      TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 19, color: Colors.blue.shade900);
  @override
  get normalHrefH2 =>
      TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 17, color: Colors.blue.shade900);
  @override
  get normalHrefH3 =>
      TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 16, color: Colors.blue.shade900);
  @override
  get normalHrefH4 =>
      TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 15, color: Colors.blue.shade900);
  @override
  get normalHrefH5 =>
      TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 14, color: Colors.blue.shade900);
  @override
  get normalHrefH6 =>
      TextStyle(fontFamily: 'HN', fontWeight: FontWeight.normal, fontSize: 13, color: Colors.blue.shade900);
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
      fontFamily: 'HN', fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.8, color: Colors.black);

  @override
  get themeButtonFontStyle => const TextStyle(
      fontFamily: 'HN', fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.8, color: Colors.white);

  TextTheme get getTextTheme => ThemeData.light().textTheme.copyWith(
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
