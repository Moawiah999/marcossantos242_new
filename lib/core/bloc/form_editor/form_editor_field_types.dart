import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

abstract class FormEditorFieldType {
  Key key;
  String defaultValue;
  BuildContext context;

  FormEditorFieldType({
    required this.key,
    required this.context,
    required this.defaultValue,
  });

  /// table field value, [UserTable]
  String get getTableField;

  /// table field hint text
  String get getHintText => '';

  // table field multi-line
  int? get getMaxLines => 1;

  /// table field placeholder text
  String get getPlaceholderText;

  String get getAnimatedPlaceholderText => getPlaceholderText;

  /// Field leading icon data
  IconData? get getPrefixIconData => null;

  /// is obscured
  bool get isObscured => false;
}

class FormEditorFieldUserDisplayName extends FormEditorFieldType {
  FormEditorFieldUserDisplayName({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          defaultValue: defaultValue,
          key: KeyGen.from(AppWidgetKey.displayNameProfilePageTextField),
        );

  @override
  String get getHintText => AppLocalizations.of(context)!.changeDisplayNameHint;

  @override
  String get getPlaceholderText => AppLocalizations.of(context)!.displayName;

  @override
  String get getTableField => UserTable.displayName;
}

class FormEditorFieldUserUsername extends FormEditorFieldType {
  FormEditorFieldUserUsername({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          defaultValue: defaultValue,
          key: KeyGen.from(AppWidgetKey.usernameProfilePageTextField),
        );

  @override
  String get getHintText => AppLocalizations.of(context)!.changeUsernameHint;

  @override
  String get getPlaceholderText => AppLocalizations.of(context)!.username;

  @override
  IconData? get getPrefixIconData => Icons.person_outline;

  @override
  String get getTableField => UserTable.username;
}

class FormEditorFieldUserDisplayBio extends FormEditorFieldType {
  FormEditorFieldUserDisplayBio({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          defaultValue: defaultValue,
          key: KeyGen.from(AppWidgetKey.displayBioProfilePageTextField),
        );

  @override
  String get getHintText => AppLocalizations.of(context)!.changeDisplayBioHint;

  @override
  String get getPlaceholderText => AppLocalizations.of(context)!.displayBio;

  @override
  String get getTableField => UserTable.displayBio;

  @override
  int? get getMaxLines => null;
}

class FormEditorFieldUserDisplayWeb extends FormEditorFieldType {
  FormEditorFieldUserDisplayWeb({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          defaultValue: defaultValue,
          key: KeyGen.from(AppWidgetKey.displayWebProfilePageTextField),
        );

  @override
  String get getHintText => AppLocalizations.of(context)!.changeDisplayWebHint;

  @override
  String get getPlaceholderText => AppLocalizations.of(context)!.displayWeb;

  @override
  String get getTableField => UserTable.displayWeb;
}

class FormEditorFieldUserEmail extends FormEditorFieldType {
  FormEditorFieldUserEmail({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          defaultValue: defaultValue,
          key: KeyGen.from(AppWidgetKey.emailProfilePageTextField),
        );

  @override
  String get getHintText => AppLocalizations.of(context)!.changeEmailAddressHint;

  @override
  String get getPlaceholderText => AppLocalizations.of(context)!.emailAddress;

  @override
  IconData? get getPrefixIconData => Icons.mail_outline;

  @override
  String get getTableField => UserTable.email;
}

class FormEditorFieldCurrentPassword extends FormEditorFieldType {
  FormEditorFieldCurrentPassword({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          defaultValue: defaultValue,
          key: KeyGen.from(AppWidgetKey.currentPasswordProfilePageTextField),
        );

  @override
  String get getPlaceholderText => AppLocalizations.of(context)!.currentPassword;

  @override
  String get getTableField => UserTable.password;

  @override
  bool get isObscured => true;
}

class FormEditorFieldUserNewPassword extends FormEditorFieldType {
  FormEditorFieldUserNewPassword({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          defaultValue: defaultValue,
          key: KeyGen.from(AppWidgetKey.newPasswordProfilePageTextField),
        );

  @override
  String get getPlaceholderText => AppLocalizations.of(context)!.newPassword;

  @override
  String get getTableField => UserTable.extraNewPassword;

  @override
  bool get isObscured => true;
}

class FormEditorFieldUserRetypeNewPassword extends FormEditorFieldType {
  FormEditorFieldUserRetypeNewPassword({
    required BuildContext context,
    required String defaultValue,
  }) : super(
          context: context,
          defaultValue: defaultValue,
          key: KeyGen.from(AppWidgetKey.retypeNewPasswordProfilePageTextField),
        );

  @override
  String get getPlaceholderText => AppLocalizations.of(context)!.retypeNewPassword;

  @override
  String get getTableField => UserTable.extraRetypeNewPassword;

  @override
  bool get isObscured => true;
}
