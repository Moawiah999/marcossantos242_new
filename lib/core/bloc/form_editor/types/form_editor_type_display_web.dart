import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class FormEditorTypeDisplayWeb extends FormEditorType {
  @override
  Map<String, String> getErrorMap(String responseCode) {
    switch (responseCode) {
      case D_ERROR_USER_DISPLAY_WEB_MAX_LEN_MSG:
        return {
          UserTable.displayWeb: sprintf(
            AppLocalizations.of(context)!.fieldErrorUserDisplayWebMaxLength,
            [
              AppSettings.getString(SETTING_MAX_LEN_USER_DISPLAY_WEB),
            ],
          )
        };

      case D_ERROR_USER_DISPLAY_WEB_MIN_LEN_MSG:
        return {
          UserTable.displayWeb: sprintf(
            AppLocalizations.of(context)!.fieldErrorUserDisplayWebMinLength,
            [
              AppSettings.getString(SETTING_MIN_LEN_USER_DISPLAY_WEB),
            ],
          )
        };

      case D_ERROR_USER_DISPLAY_WEB_INVALID_FORMAT_MSG:
        return {UserTable.displayWeb: AppLocalizations.of(context)!.fieldErrorUserDisplayWebInvalidFormat};
    }
    return {};
  }

  FormEditorTypeDisplayWeb({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          requestType: REQ_TYPE_UPDATE_USER_DISPLAY_WEB,
          fields: <FormEditorFieldType>[
            FormEditorFieldUserDisplayWeb(context: context, defaultValue: defaultValue),
          ],
        );
}
