import 'package:flutter/material.dart';

abstract class FormEditorEvent {
  final BuildContext context;
  FormEditorEvent(this.context);
}

class FormEditorEventSaveFieldsData extends FormEditorEvent {
  final Map<String, String> fieldDataMap;

  FormEditorEventSaveFieldsData(
    BuildContext context, {
    required this.fieldDataMap,
  }) : super(context);
}
