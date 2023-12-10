import 'package:flutter/material.dart';

abstract class PgThemeModeImplementation {
  ThemeData get themeData;

  ColorScheme get colorScheme;

  TextStyle get boldBlackH1;
  TextStyle get boldBlackH2;
  TextStyle get boldBlackH3;
  TextStyle get boldBlackH4;
  TextStyle get boldBlackH5;
  TextStyle get boldBlackH6;

  TextStyle get normalBlackH1;
  TextStyle get normalBlackH2;
  TextStyle get normalBlackH3;
  TextStyle get normalBlackH4;
  TextStyle get normalBlackH5;
  TextStyle get normalBlackH6;

  TextStyle get normalGreyH1;
  TextStyle get normalGreyH2;
  TextStyle get normalGreyH3;
  TextStyle get normalGreyH4;
  TextStyle get normalGreyH5;
  TextStyle get normalGreyH6;

  TextStyle get normalHrefH1;
  TextStyle get normalHrefH2;
  TextStyle get normalHrefH3;
  TextStyle get normalHrefH4;
  TextStyle get normalHrefH5;
  TextStyle get normalHrefH6;

  TextStyle get normalThemeH1;
  TextStyle get normalThemeH2;
  TextStyle get normalThemeH3;
  TextStyle get normalThemeH4;
  TextStyle get normalThemeH5;
  TextStyle get normalThemeH6;

  TextStyle get hollowButtonFontStyle;
  TextStyle get themeButtonFontStyle;
}
