import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class FormEditorTypeUsername extends FormEditorType {
  @override
  Map<String, String> getErrorMap(String responseCode) {
    switch (responseCode) {
      case D_ERROR_USER_USERNAME_MAX_LEN_MSG:
        return {
          UserTable.username: sprintf(
            AppLocalizations.of(context)!.fieldErrorUserUsernameMaxLength,
            [
              AppSettings.getString(SETTING_MAX_LEN_USER_USERNAME),
            ],
          )
        };

      case D_ERROR_USER_USERNAME_MIN_LEN_MSG:
        return {
          UserTable.username: sprintf(
            AppLocalizations.of(context)!.fieldErrorUserUsernameMinLength,
            [
              AppSettings.getString(SETTING_MIN_LEN_USER_USERNAME),
            ],
          )
        };

      case D_ERROR_USER_USERNAME_NOT_AVAILABLE_MSG:
        return {UserTable.username: AppLocalizations.of(context)!.fieldErrorUserUsernameNotAvailable};

      case D_ERROR_USER_USERNAME_STARTS_WITH_ALHPABET_MSG:
        return {UserTable.username: AppLocalizations.of(context)!.fieldErrorUserUsernameMustStartsWithAlphabet};

      case D_ERROR_USER_USERNAME_ALLOWED_CHARACTERS_ONLY_MSG:
        return {UserTable.username: AppLocalizations.of(context)!.fieldErrorUserUsernameAllowedCharactersOnly};
    }
    return {};
  }

  FormEditorTypeUsername({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          requestType: REQ_TYPE_UPDATE_USER_USERNAME,
          fields: <FormEditorFieldType>[
            FormEditorFieldUserUsername(context: context, defaultValue: defaultValue),
          ],
        );
}
