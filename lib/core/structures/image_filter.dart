import 'package:flutter/material.dart';

abstract class ImageFilter {
  String get title;
  Color? get color;
  BlendMode? get colorBlendMode;
}
