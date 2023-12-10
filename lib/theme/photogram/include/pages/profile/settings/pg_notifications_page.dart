import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/settings/pg_settings_item.dart';

class PgNotificationsPage extends NotificationsPage {
  const PgNotificationsPage({Key? key}) : super(key: key);

  @override
  State<PgNotificationsPage> createState() => _PgNotificationsPageState();
}

class _PgNotificationsPageState extends State<PgNotificationsPage>
    with AppActiveContentMixin, AppUserMixin, AppUtilsMixin {
  final _settingItems = <PgSettingsItem>[];
  late final UserModel _userModel;

  @override
  void onLoadEvent() {
    _userModel = activeContent.authBloc.getCurrentUser;

    utilMixinPostSetState(() {
      _settingItems.addAll([
        PgSettingsItemHeader(context: context, headerTitle: AppLocalizations.of(context)!.pushNotifications),
        PgSettingsNotificationsPauseAll(context: context, onTap: _switchPauseAll),
        PgSettingsNotificationPostLikesAndComments(context: context),
        PgSettingsNotificationPhotosOfYou(context: context),
        PgSettingsNotificationsFollowingAndFollowers(context: context),
      ]);
    });
  }

  void _switchPauseAll() {
    utilMixinSetState(() {
      _userModel.metaPushSettings.pauseAll = _userModel.metaPushSettings.pauseAll == UserMetaPushSettingsDTO.valueOn
          ? UserMetaPushSettingsDTO.valueOff
          : UserMetaPushSettingsDTO.valueOn;

      activeContent.apiRepository.userUpdateMetaPushSettings(userPushSettingsDTO: _userModel.metaPushSettings);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.notifications)),
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
