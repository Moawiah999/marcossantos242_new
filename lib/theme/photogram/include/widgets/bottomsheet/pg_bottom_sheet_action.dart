import 'package:flutter/cupertino.dart';

class PgBottomSheetAction {
  String? title;
  bool? isHeader;
  bool? isDivider;
  bool? isRed;

  IconData? iconData;
  VoidCallback onTap;

  PgBottomSheetAction({
    this.iconData,
    this.isHeader,
    this.isDivider,
    this.isRed,
    this.title,
    required this.onTap,
  });
}
