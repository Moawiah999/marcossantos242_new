import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/settings/pg_settings_item.dart';

class PgSecurityPage extends SecurityPage {
  const PgSecurityPage({Key? key}) : super(key: key);

  @override
  State<PgSecurityPage> createState() => _PgSecurityPageState();
}

class _PgSecurityPageState extends State<PgSecurityPage> with AppUtilsMixin {
  final _settingItems = <PgSettingsItem>[];

  @override
  void initState() {
    super.initState();

    utilMixinPostSetState(() {
      _settingItems.addAll([
        PgSettingsItemHeader(context: context, headerTitle: AppLocalizations.of(context)!.loginSecurity),
        PgSettingsItemPassword(context: context),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.security)),
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
