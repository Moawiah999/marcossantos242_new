import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class FormEditorTypeEmail extends FormEditorType {
  @override
  Map<String, String> getErrorMap(String responseCode) {
    switch (responseCode) {
      case D_ERROR_USER_EMAIL_MAX_LEN_MSG:
        return {
          UserTable.email: sprintf(
            AppLocalizations.of(context)!.fieldErrorUserEmailMaxLength,
            [
              AppSettings.getString(SETTING_MAX_LEN_USER_EMAIL),
            ],
          )
        };

      case D_ERROR_USER_EMAIL_MIN_LEN_MSG:
        return {
          UserTable.email: sprintf(
            AppLocalizations.of(context)!.fieldErrorUserEmailMinLength,
            [
              AppSettings.getString(SETTING_MIN_LEN_USER_EMAIL),
            ],
          )
        };

      case D_ERROR_USER_EMAIL_INVALID_FORMAT_MSG:
        return {UserTable.email: AppLocalizations.of(context)!.fieldErrorUserEmailInvalidFormat};

      case D_ERROR_USER_EMAIL_NOT_AVAILABLE_MSG:
        return {UserTable.email: AppLocalizations.of(context)!.fieldErrorUserEmailNotAvailable};
    }
    return {};
  }

  FormEditorTypeEmail({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          requestType: REQ_TYPE_UPDATE_USER_EMAIL,
          fields: <FormEditorFieldType>[
            FormEditorFieldUserEmail(context: context, defaultValue: defaultValue),
          ],
        );
}
