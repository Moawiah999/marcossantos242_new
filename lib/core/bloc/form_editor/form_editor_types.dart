import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:photogram/import/bloc.dart';

abstract class FormEditorType {
  String requestType;
  BuildContext context;

  List<FormEditorFieldType> fields;

  Map<String, String> getErrorMap(String responseCode) => {};

  FormEditorType({
    required this.context,
    required this.requestType,
    required this.fields,
  });
}
