import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class FormEditorTypeDisplayName extends FormEditorType {
  @override
  Map<String, String> getErrorMap(String responseCode) {
    switch (responseCode) {
      case D_ERROR_USER_DISPLAY_NAME_MAX_LEN_MSG:
        return {
          UserTable.displayName: sprintf(
            AppLocalizations.of(context)!.fieldErrorUserDisplayNameMaxLength,
            [
              AppSettings.getString(SETTING_MAX_LEN_USER_DISPLAY_NAME),
            ],
          )
        };

      case D_ERROR_USER_DISPLAY_NAME_MIN_LEN_MSG:
        return {
          UserTable.displayName: sprintf(
            AppLocalizations.of(context)!.fieldErrorUserDisplayNameMinLength,
            [
              AppSettings.getString(SETTING_MIN_LEN_USER_DISPLAY_NAME),
            ],
          )
        };
    }
    return {};
  }

  FormEditorTypeDisplayName({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          requestType: REQ_TYPE_UPDATE_USER_DISPLAY_NAME,
          fields: <FormEditorFieldType>[
            FormEditorFieldUserDisplayName(context: context, defaultValue: defaultValue),
          ],
        );
}
