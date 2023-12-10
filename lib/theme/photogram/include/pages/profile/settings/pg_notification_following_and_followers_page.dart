import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/settings/pg_settings_item.dart';

class PgNotificationFollowingAndFollowersPage extends StatefulWidget {
  const PgNotificationFollowingAndFollowersPage({Key? key}) : super(key: key);

  @override
  State<PgNotificationFollowingAndFollowersPage> createState() => _PgNotificationFollowingAndFollowersPageState();
}

class _PgNotificationFollowingAndFollowersPageState extends State<PgNotificationFollowingAndFollowersPage>
    with AppActiveContentMixin, AppUserMixin, AppUtilsMixin {
  late final UserModel _userModel;

  @override
  void onLoadEvent() {
    _userModel = activeContent.authBloc.getCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.followingAndFollowers)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildAcceptedFollowRequestSettings(),
                PgUtils.sizedBoxH(10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOptions({required String currentSettingValue, required List<SettingOption> options}) {
    var listTiles = <Widget>[];

    for (var option in options) {
      listTiles.add(
        ListTile(
          onTap: option.onTap,
          dense: true,
          title: ThemeBloc.textInterface.normalBlackH4Text(text: option.title),
          trailing: (currentSettingValue == option.activatingValue)
              ? Icon(
                  Icons.check_circle,
                  color: ThemeBloc.colorScheme.primary,
                )
              : const Icon(Icons.circle_outlined),
        ),
      );
    }

    return listTiles;
  }

  void save(VoidCallback callback) {
    utilMixinSetState(() {
      callback();
      activeContent.apiRepository.userUpdateMetaPushSettings(userPushSettingsDTO: _userModel.metaPushSettings);
    });
  }

  List<Widget> _buildAcceptedFollowRequestSettings() {
    return [
      PgUtils.sizedBoxH(10),
      PgSettingsItemHeader(context: context, headerTitle: AppLocalizations.of(context)!.acceptedFollowRequests).build(),
      ..._buildOptions(
        currentSettingValue: _userModel.metaPushSettings.acceptedFollowRequest,
        options: [
          SettingOption(
            title: AppLocalizations.of(context)!.valueOff,
            activatingValue: UserMetaPushSettingsDTO.valueOff,
            onTap: () => save(() {
              _userModel.metaPushSettings.acceptedFollowRequest = UserMetaPushSettingsDTO.valueOff;
            }),
          ),
          SettingOption(
            title: AppLocalizations.of(context)!.valueOn,
            activatingValue: UserMetaPushSettingsDTO.valueOn,
            onTap: () => save(() {
              _userModel.metaPushSettings.acceptedFollowRequest = UserMetaPushSettingsDTO.valueOn;
            }),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            ThemeBloc.textInterface.normalGreyH5Text(text: AppLocalizations.of(context)!.johnAcceptedYourFollowRequest),
      ),
      PgUtils.sizedBoxH(15),
    ];
  }
}

class SettingOption {
  String title;
  String activatingValue;
  VoidCallback onTap;

  SettingOption({
    required this.title,
    required this.activatingValue,
    required this.onTap,
  });
}
