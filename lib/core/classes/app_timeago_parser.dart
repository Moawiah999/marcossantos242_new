import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:timeago/timeago.dart';

import 'package:photogram/import/core.dart';

class AppTimeAgoParser {
  BuildContext context;

  AppTimeAgoParser(this.context) {
    /*
    |--------------------------------------------------------------------------
    | add locale messages:
    |--------------------------------------------------------------------------
    */

    setLocaleMessages('en', AppTimeAgoLongMessages(context));
    setLocaleMessages('en_short', AppTimeAgoShortMessages(context));
  }

  static String parse(String timestamp) => format(DateTime.parse(timestamp + 'Z').toLocal(), locale: 'en');

  static String parseShort(String timestamp) => format(DateTime.parse(timestamp + 'Z').toLocal(), locale: 'en_short');
}

class AppTimeAgoLongMessages implements LookupMessages {
  BuildContext context;

  AppTimeAgoLongMessages(this.context);

  @override
  String prefixAgo() => AppLocalizations.of(context)!.prefixAgo;
  @override
  String prefixFromNow() => AppLocalizations.of(context)!.prefixFromNow;
  @override
  String suffixAgo() => AppLocalizations.of(context)!.suffixAgo;
  @override
  String suffixFromNow() => AppLocalizations.of(context)!.suffixFromNow;
  @override
  String lessThanOneMinute(int seconds) => sprintf(AppLocalizations.of(context)!.lessThanOneMinute, [seconds]);
  @override
  String aboutAMinute(int minutes) => sprintf(AppLocalizations.of(context)!.aboutAMinute, [minutes]);
  @override
  String minutes(int minutes) => sprintf(AppLocalizations.of(context)!.minutes, [minutes]);
  @override
  String aboutAnHour(int minutes) => sprintf(AppLocalizations.of(context)!.aboutAnHour, [minutes]);
  @override
  String hours(int hours) => sprintf(AppLocalizations.of(context)!.hours, [hours]);
  @override
  String aDay(int hours) => sprintf(AppLocalizations.of(context)!.aDay, [hours]);
  @override
  String days(int days) => sprintf(AppLocalizations.of(context)!.days, [days]);
  @override
  String aboutAMonth(int days) => sprintf(AppLocalizations.of(context)!.aboutAMonth, [days]);
  @override
  String months(int months) => sprintf(AppLocalizations.of(context)!.months, [months]);
  @override
  String aboutAYear(int year) => sprintf(AppLocalizations.of(context)!.aboutAYear, [year]);
  @override
  String years(int years) => sprintf(AppLocalizations.of(context)!.years, [years]);
  @override
  String wordSeparator() => AppLocalizations.of(context)!.wordSeparator;
}

class AppTimeAgoShortMessages implements LookupMessages {
  BuildContext context;
  AppTimeAgoShortMessages(this.context);

  @override
  String prefixAgo() => AppLocalizations.of(context)!.shortPrefixAgo;
  @override
  String prefixFromNow() => AppLocalizations.of(context)!.shortPrefixFromNow;
  @override
  String suffixAgo() => AppLocalizations.of(context)!.shortSuffixAgo;
  @override
  String suffixFromNow() => AppLocalizations.of(context)!.shortSuffixFromNow;
  @override
  String lessThanOneMinute(int seconds) => sprintf(AppLocalizations.of(context)!.shortLessThanOneMinute, [seconds]);
  @override
  String aboutAMinute(int minutes) => sprintf(AppLocalizations.of(context)!.shortAboutAMinute, [minutes]);
  @override
  String minutes(int minutes) => sprintf(AppLocalizations.of(context)!.shortMinutes, [minutes]);
  @override
  String aboutAnHour(int minutes) => sprintf(AppLocalizations.of(context)!.shortAboutAnHour, [minutes]);
  @override
  String hours(int hours) => sprintf(AppLocalizations.of(context)!.shortHours, [hours]);
  @override
  String aDay(int hours) => sprintf(AppLocalizations.of(context)!.shortADay, [hours]);
  @override
  String days(int days) => sprintf(AppLocalizations.of(context)!.shortDays, [days]);
  @override
  String aboutAMonth(int days) => sprintf(AppLocalizations.of(context)!.shortAboutAMonth, [days]);
  @override
  String months(int months) => sprintf(AppLocalizations.of(context)!.shortMonths, [months]);
  @override
  String aboutAYear(int year) => sprintf(AppLocalizations.of(context)!.shortAboutAYear, [year]);
  @override
  String years(int years) => sprintf(AppLocalizations.of(context)!.shortYears, [years]);
  @override
  String wordSeparator() => AppLocalizations.of(context)!.shortWordSeparator;
}
