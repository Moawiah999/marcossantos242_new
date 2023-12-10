import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';

class AppUtils {
  static String compactNumber(int number) => NumberFormat.compact().format(number).toString().toLowerCase();

  static int intVal(dynamic value) {
    switch (value.runtimeType) {
      case int:
        return value;

      case double:
        return int.parse(value.toString());

      case String:
      default:
        return int.parse(value);
    }
  }

  static ButtonWidgetSignature button(AppButtonProperties typeProperty, AppButtonProperties sizeProperty) {
    switch (typeProperty) {
      case AppButtonProperties.hollow:
        return hollowButton(sizeProperty);

      case AppButtonProperties.theme:
      default:
        return themeButton(sizeProperty);
    }
  }

  static Widget nothing() => const SizedBox.shrink();

  static ButtonWidgetSignature hollowButton(AppButtonProperties sizeProperty) {
    switch (sizeProperty) {
      case AppButtonProperties.standard:
        return ThemeBloc.widgetInterface.hollowButton;

      case AppButtonProperties.stretched:
      default:
        return ThemeBloc.widgetInterface.hollowButton;
    }
  }

  static ButtonWidgetSignature themeButton(AppButtonProperties sizeProperty) {
    switch (sizeProperty) {
      case AppButtonProperties.standard:
        return ThemeBloc.widgetInterface.themeButton;

      case AppButtonProperties.stretched:
      default:
        return ThemeBloc.widgetInterface.themeButton;
    }
  }
}
