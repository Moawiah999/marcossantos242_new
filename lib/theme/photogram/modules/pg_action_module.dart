import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/theme.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgActionModule {
  PhotogramTheme photogramTheme;
  PgActionModule(this.photogramTheme);

  void showMessageInsidePopUp({
    Key? key,
    required bool waitForFrame,
    required BuildContext context,
    required String message,
  }) {
    PgUtils.showPopUpWithOptions(
      key: key,
      waitForFrame: waitForFrame,
      context: context,
      options: [
        PgUtils.popUpOption(content: message, buildContext: context),
      ],
      addOkButton: true,
      addCancelButton: false,
    );
  }

  bool openProfilePage({
    required BuildContext buildContext,
    required int userId,
    required void Function() refreshCallback,
  }) {
    return AppNavigation.push(
      buildContext,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.profilePage(userId: userId),
      ),
      refreshCallback,
    );
  }

  bool openEditProfilePage({
    required BuildContext buildContext,
    required int userId,
    required void Function() refreshCallback,
  }) {
    return AppNavigation.push(
      buildContext,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.editProfilePage(userId: userId),
      ),
      refreshCallback,
    );
  }
}
