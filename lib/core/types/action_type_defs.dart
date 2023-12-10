///
/// important user actions that a theme implementation should handle
///

import 'package:flutter/material.dart';

typedef ShowMessageInsidePopUpSignature = void Function({
  Key? key,
  required bool waitForFrame,
  required BuildContext context,
  required String message,
});

typedef OpenPageUsingUserIdSignature = void Function({
  required BuildContext buildContext,
  required int userId,
  required void Function() refreshCallback,
});
