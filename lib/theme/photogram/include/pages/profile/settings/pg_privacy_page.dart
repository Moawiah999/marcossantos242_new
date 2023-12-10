import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/bottomsheet/pg_change_account_privacy_bottom_sheet.dart';
import 'package:photogram/theme/photogram/include/widgets/settings/pg_settings_item.dart';

class PgPrivacyPage extends PrivacyPage {
  const PgPrivacyPage({Key? key}) : super(key: key);

  @override
  State<PgPrivacyPage> createState() => _PgPrivacyPageState();
}

class _PgPrivacyPageState extends State<PgPrivacyPage> with AppUserMixin, AppUtilsMixin {
  final _settingItems = <PgSettingsItem>[];

  @override
  void initState() {
    super.initState();

    utilMixinPostSetState(() {
      _settingItems.addAll([
        PgSettingsItemHeader(context: context, headerTitle: AppLocalizations.of(context)!.accountPrivacy),
        PgSettingsAccountPrivacy(context: context, onTap: _changeAccountPrivacy),
        PgSettingsItemHeader(context: context, headerTitle: AppLocalizations.of(context)!.connections),
        PgSettingsItemBlockedAccounts(context: context),
      ]);
    });
  }

  void _changeAccountPrivacy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) => PgChangeAccountPrivacyBottomSheet(
            handlerSetMetaIsPrivate: userMixinSetAccountPrivacy,
          ),
        );
      },
    ).whenComplete(() {
      utilMixinSetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.privacy)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PgUtils.sizedBoxH(20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _settingItems.length,
                  itemBuilder: (context, index) => _settingItems[index].build(),
                ),
                PgUtils.sizedBoxH(15),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
