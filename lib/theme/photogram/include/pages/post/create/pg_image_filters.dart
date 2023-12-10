import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';

class PgImageFilterNone extends ImageFilter {
  late final String _title;

  PgImageFilterNone(BuildContext context) {
    _title = AppLocalizations.of(context)!.filterNone;
  }

  @override
  String get title => _title;

  @override
  Color? get color => null;

  @override
  BlendMode? get colorBlendMode => null;
}

class PgImageFilterExclusion extends ImageFilter {
  late final String _title;

  PgImageFilterExclusion(BuildContext context) {
    _title = AppLocalizations.of(context)!.filterExclusion;
  }

  @override
  String get title => _title;

  @override
  Color get color => Colors.blue.shade800.withOpacity(0.5);

  @override
  BlendMode get colorBlendMode => BlendMode.exclusion;
}

class PgImageFilterGrayScale extends ImageFilter {
  late final String _title;

  PgImageFilterGrayScale(BuildContext context) {
    _title = AppLocalizations.of(context)!.filterGrayScale;
  }

  @override
  String get title => _title;

  @override
  Color get color => Colors.grey;

  @override
  BlendMode get colorBlendMode => BlendMode.saturation;
}

class PgImageFilterRetro extends ImageFilter {
  late final String _title;

  PgImageFilterRetro(BuildContext context) {
    _title = AppLocalizations.of(context)!.filterRetro;
  }

  @override
  String get title => _title;

  @override
  Color get color => Colors.yellow.shade900.withOpacity(0.5);

  @override
  BlendMode get colorBlendMode => BlendMode.luminosity;
}

class PgImageFilterSepiaScale extends ImageFilter {
  late final String _title;

  PgImageFilterSepiaScale(BuildContext context) {
    _title = AppLocalizations.of(context)!.filterSepiaScale;
  }

  @override
  String get title => _title;

  @override
  Color get color => Colors.yellow.shade900.withOpacity(0.7);

  @override
  BlendMode get colorBlendMode => BlendMode.multiply;
}

class PgImageFilterNight extends ImageFilter {
  late final String _title;

  PgImageFilterNight(BuildContext context) {
    _title = AppLocalizations.of(context)!.filterNight;
  }

  @override
  String get title => _title;

  @override
  Color get color => Colors.blue.shade900.withOpacity(0.5);

  @override
  BlendMode get colorBlendMode => BlendMode.multiply;
}

class PgImageFilterBrave extends ImageFilter {
  late final String _title;

  PgImageFilterBrave(BuildContext context) {
    _title = AppLocalizations.of(context)!.filterBrave;
  }

  @override
  String get title => _title;

  @override
  Color get color => Colors.purpleAccent.withOpacity(0.5);

  @override
  BlendMode get colorBlendMode => BlendMode.softLight;
}

class PgImageFilterRatio extends ImageFilter {
  late final String _title;

  PgImageFilterRatio(BuildContext context) {
    _title = AppLocalizations.of(context)!.filterRatio;
  }

  @override
  String get title => _title;

  @override
  Color get color => const Color(0xff0d69ff).withOpacity(1.0);

  @override
  BlendMode get colorBlendMode => BlendMode.softLight;
}
