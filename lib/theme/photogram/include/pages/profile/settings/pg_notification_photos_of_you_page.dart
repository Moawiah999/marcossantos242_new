import 'package:flutter/material.dart';
import 'package:photogram/core/bloc/theme/theme_bloc.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/settings/pg_settings_item.dart';

class PgNotificationPhotosOfYou extends StatefulWidget {
  const PgNotificationPhotosOfYou({Key? key}) : super(key: key);

  @override
  State<PgNotificationPhotosOfYou> createState() => _PgNotificationPhotosOfYouState();
}

class _PgNotificationPhotosOfYouState extends State<PgNotificationPhotosOfYou>
    with AppActiveContentMixin, AppUserMixin, AppUtilsMixin {
  late final UserModel _userModel;

  @override
  void onLoadEvent() {
    _userModel = activeContent.authBloc.getCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.photosOfYou)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildPhotosOfYouSettings(),
                ThemeBloc.widgetInterface.divider(),
                ..._buildLikesSettings(),
                ThemeBloc.widgetInterface.divider(),
                ..._buildCommentsSettings(),
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

  List<Widget> _buildPhotosOfYouSettings() {
    return [
      PgUtils.sizedBoxH(10),
      PgSettingsItemHeader(context: context, headerTitle: AppLocalizations.of(context)!.photosOfYou).build(),
      ..._buildOptions(
        currentSettingValue: _userModel.metaPushSettings.photosOfYou,
        options: [
          SettingOption(
            title: AppLocalizations.of(context)!.valueOff,
            activatingValue: UserMetaPushSettingsDTO.valueOff,
            onTap: () => save(() {
              _userModel.metaPushSettings.photosOfYou = UserMetaPushSettingsDTO.valueOff;
            }),
          ),
          SettingOption(
            title: AppLocalizations.of(context)!.fromPeopleIFollow,
            activatingValue: UserMetaPushSettingsDTO.valueFromPeopleIFollow,
            onTap: () => save(() {
              _userModel.metaPushSettings.photosOfYou = UserMetaPushSettingsDTO.valueFromPeopleIFollow;
            }),
          ),
          SettingOption(
            title: AppLocalizations.of(context)!.fromEveryone,
            activatingValue: UserMetaPushSettingsDTO.valueFromEveryone,
            onTap: () => save(() {
              _userModel.metaPushSettings.photosOfYou = UserMetaPushSettingsDTO.valueFromEveryone;
            }),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ThemeBloc.textInterface.normalGreyH5Text(text: AppLocalizations.of(context)!.johnTaggedYouInAPhoto),
      ),
      PgUtils.sizedBoxH(15),
    ];
  }

  List<Widget> _buildLikesSettings() {
    return [
      PgUtils.sizedBoxH(15),
      PgSettingsItemHeader(context: context, headerTitle: AppLocalizations.of(context)!.likesOnPhotosOfYou).build(),
      ..._buildOptions(
        currentSettingValue: _userModel.metaPushSettings.likesOnPhotosOfYou,
        options: [
          SettingOption(
            title: AppLocalizations.of(context)!.valueOff,
            activatingValue: UserMetaPushSettingsDTO.valueOff,
            onTap: () => save(() {
              _userModel.metaPushSettings.likesOnPhotosOfYou = UserMetaPushSettingsDTO.valueOff;
            }),
          ),
          SettingOption(
            title: AppLocalizations.of(context)!.valueOn,
            activatingValue: UserMetaPushSettingsDTO.valueOn,
            onTap: () => save(() {
              _userModel.metaPushSettings.likesOnPhotosOfYou = UserMetaPushSettingsDTO.valueOn;
            }),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ThemeBloc.textInterface.normalGreyH5Text(text: AppLocalizations.of(context)!.johnLikedPhotoOfYou),
      ),
      PgUtils.sizedBoxH(15),
    ];
  }

  List<Widget> _buildCommentsSettings() {
    return [
      PgUtils.sizedBoxH(10),
      PgSettingsItemHeader(context: context, headerTitle: AppLocalizations.of(context)!.commentsOnPhotosOfYou).build(),
      ..._buildOptions(
        currentSettingValue: _userModel.metaPushSettings.commentsOnPhotosOfYou,
        options: [
          SettingOption(
            title: AppLocalizations.of(context)!.valueOff,
            activatingValue: UserMetaPushSettingsDTO.valueOff,
            onTap: () => save(() {
              _userModel.metaPushSettings.commentsOnPhotosOfYou = UserMetaPushSettingsDTO.valueOff;
            }),
          ),
          SettingOption(
            title: AppLocalizations.of(context)!.valueOn,
            activatingValue: UserMetaPushSettingsDTO.valueOn,
            onTap: () => save(() {
              _userModel.metaPushSettings.commentsOnPhotosOfYou = UserMetaPushSettingsDTO.valueOn;
            }),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ThemeBloc.textInterface.normalGreyH5Text(text: AppLocalizations.of(context)!.johnCommentedOnPhotoOfYou),
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
