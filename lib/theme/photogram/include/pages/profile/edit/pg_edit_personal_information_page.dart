import 'package:flutter/material.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgEditPersonalInformationPage extends EditPersonalInformationPage {
  final int userId;

  const PgEditPersonalInformationPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _PgEditPersonalInformationPageState createState() => _PgEditPersonalInformationPageState();
}

class _PgEditPersonalInformationPageState extends State<PgEditPersonalInformationPage>
    with AppActiveContentMixin, AppUtilsMixin {
  late UserModel _userModel;

  @override
  void onLoadEvent() {
    _userModel = activeContent.watch<UserModel>(widget.userId) ?? UserModel.none();
  }

  @override
  Widget build(BuildContext context) {
    if (_userModel.isNotModel) {
      return AppLogger.fail('${_userModel.runtimeType}(${widget.userId})');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(AppLocalizations.of(context)!.personalInformation),
        leading: GestureDetector(
          key: KeyGen.from(AppWidgetKey.backEditPersonalInformationPageIcon),
          onTap: () => AppNavigation.pop(),
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          GestureDetector(
            key: KeyGen.from(AppWidgetKey.saveEditPersonalInformationPageIcon),
            onTap: () => AppNavigation.pop(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Icon(Icons.check, color: ThemeBloc.colorScheme.primary),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PgUtils.sizedBoxH(15),
              ThemeBloc.textInterface
                  .normalGreyH6Text(text: AppLocalizations.of(context)!.personalInformationSettingsHint),
              PgUtils.sizedBoxH(15),
              emailField(context, _userModel),
              PgUtils.sizedBoxH(15),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailField(BuildContext context, UserModel user) {
    return PgUtils.fieldViewHref(
      context: context,
      key: KeyGen.from(AppWidgetKey.emailProfilePageFieldView),
      screenTitle: AppLocalizations.of(context)!.emailAddress,
      screenDescription: AppLocalizations.of(context)!.changeEmailAddressHint,
      fieldDefaultValue: user.email,
      fieldPlaceholderText: AppLocalizations.of(context)!.emailAddress,
      formEditorType: FormEditorTypeEmail(
        context: context,
        defaultValue: user.email,
      ),
      refreshCallback: utilMixinSetState,
    );
  }
}
