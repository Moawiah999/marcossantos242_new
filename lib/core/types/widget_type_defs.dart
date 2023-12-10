///
/// few important widgets
///

import 'package:flutter/material.dart';

typedef DividerSignature = Divider Function();

typedef TextStyleSignature = TextStyle Function();

typedef TextWidgetSignature = Text Function({
  Key? key,
  required String text,
});

typedef TextSpanWidgetSignature = TextSpan Function({
  required String text,
});

typedef ButtonWidgetSignature = Widget Function({
  Key? key,
  required String text,
  required Function onTapCallback,
});

typedef TextFieldWidgetSignature = TextField Function({
  Key? key,
  Widget? label,
  String? hintText,
  Widget? prefixIcon,
  FocusNode? focusNode,
  String? errorText,
  bool? obscureText,
  InputBorder? border,
  required BuildContext context,
  TextEditingController? controller,
});
