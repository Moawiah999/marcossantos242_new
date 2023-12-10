import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:photogram/import/core.dart';

class AppLogger {
  static void exception(Object e) {
    if (CLIENT_DEBUG) {
      // ignore: avoid_print
      print(e);
      info(e);
    }
  }

  static void info(message, {String? error, AppLogType logType = AppLogType.other}) {
    if (CLIENT_DEBUG) {
      dev.log(message.toString());

      if (null != error) {
        dev.log(error);
      }
    }
  }

  static void navigationInfo(message) => AppLogger.info(message, logType: AppLogType.navigation);
  static void blockInfo(message) => AppLogger.info(message, logType: AppLogType.bloc);

  static Widget fail(String message) {
    info('ActiveContent: Unable to watch $message');
    return const SizedBox.shrink();
  }

  static void high(message) => AppLogger.info(message, logType: AppLogType.highPriorityDebug);
}
