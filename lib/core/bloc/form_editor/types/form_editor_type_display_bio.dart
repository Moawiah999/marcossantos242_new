import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class FormEditorTypeDisplayBio extends FormEditorType {
  @override
  Map<String, String> getErrorMap(String responseCode) {
    switch (responseCode) {
      case D_ERROR_USER_DISPLAY_BIO_MAX_LEN_MSG:
        return {
          UserTable.displayBio: sprintf(
            AppLocalizations.of(context)!.fieldErrorUserDisplayBioMaxLength,
            [
              AppSettings.getString(SETTING_MAX_LEN_USER_DISPLAY_BIO),
            ],
          )
        };

      case D_ERROR_USER_DISPLAY_BIO_MIN_LEN_MSG:
        return {
          UserTable.displayBio: sprintf(
            AppLocalizations.of(context)!.fieldErrorUserDisplayBioMinLength,
            [
              AppSettings.getString(SETTING_MIN_LEN_USER_DISPLAY_BIO),
            ],
          )
        };
    }
    return {};
  }

  FormEditorTypeDisplayBio({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          requestType: REQ_TYPE_UPDATE_USER_DISPLAY_BIO,
          fields: <FormEditorFieldType>[
            FormEditorFieldUserDisplayBio(context: context, defaultValue: defaultValue),
          ],
        );
}
