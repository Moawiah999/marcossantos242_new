///
/// used inside core, theme has to implement this as well
///

import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

typedef UserAppTile = AppTile Function({
  Key? key,
  required UserModel userModel,
});
