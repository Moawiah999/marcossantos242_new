import 'package:sprintf/sprintf.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class FormEditorTypePassword extends FormEditorType {
  @override
  Map<String, String> getErrorMap(String responseCode) {
    switch (responseCode) {
      case D_ERROR_USER_PASSWORD_MAX_LEN_MSG:
        return {
          UserTable.extraNewPassword: sprintf(
            AppLocalizations.of(context)!.fieldErrorUserPasswordMaxLength,
            [
              AppSettings.getString(SETTING_MAX_LEN_USER_PASSWORD),
            ],
          )
        };

      case D_ERROR_USER_PASSWORD_MIN_LEN_MSG:
        return {
          UserTable.extraNewPassword: sprintf(
            AppLocalizations.of(context)!.fieldErrorUserPasswordMinLength,
            [
              AppSettings.getString(SETTING_MIN_LEN_USER_PASSWORD),
            ],
          )
        };

      case D_ERROR_USER_NOT_MATCHED_MSG:
        return {UserTable.password: AppLocalizations.of(context)!.loginErrorPasswordNotMatched};

      case D_ERROR_USER_PASSWORD_MISMATCH_MSG:
        return {UserTable.extraRetypeNewPassword: AppLocalizations.of(context)!.fieldErrorUserPasswordMismatch};
    }

    return {};
  }

  FormEditorTypePassword({
    required context,
  }) : super(
          context: context,
          requestType: REQ_TYPE_UPDATE_USER_PASSWORD,
          fields: <FormEditorFieldType>[
            FormEditorFieldCurrentPassword(context: context, defaultValue: ''),
            FormEditorFieldUserNewPassword(context: context, defaultValue: ''),
            FormEditorFieldUserRetypeNewPassword(context: context, defaultValue: ''),
          ],
        );
}
