import 'package:flutter/material.dart';
import 'package:photogram/core/data/dtos/user/user_meta_push_settings_dto.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/theme/photogram/include/pages/profile/settings/pg_notification_following_and_followers_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/settings/pg_notification_photos_of_you_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/settings/pg_notification_posts_likes_and_tags_page.dart';

abstract class PgSettingsItem {
  BuildContext context;

  String get getTitle => '';

  EdgeInsets get getPadding => const EdgeInsets.symmetric(horizontal: 10);

  VoidCallback? get getOnTap => null;

  TextStyle? get getTextStyle => Theme.of(context).textTheme.subtitle2;

  IconData? get getPrefixIconData => null;

  Icon? get getPrefixIcon => Icon(
        getPrefixIconData,
        size: 25,
        color: Theme.of(context).colorScheme.onBackground,
      );

  Widget build() {
    return Padding(
      padding: getPadding,
      child: ListTile(
        leading: getPrefixIcon,
        title: Text(
          getTitle,
          style: getTextStyle,
        ),
        minLeadingWidth: 0,
        onTap: getOnTap,
      ),
    );
  }

  PgSettingsItem({required this.context});
}

class PgSettingsItemHeader extends PgSettingsItem {
  final String headerTitle;

  PgSettingsItemHeader({
    required BuildContext context,
    required this.headerTitle,
  }) : super(context: context);

  @override
  String get getTitle => headerTitle;

  @override
  EdgeInsets get getPadding => const EdgeInsets.all(0);

  @override
  Icon? get getPrefixIcon => null;

  @override
  TextStyle? get getTextStyle => ThemeBloc.textInterface.boldBlackH4TextStyle();
}

class PgSettingsItemDivider extends PgSettingsItem {
  PgSettingsItemDivider({
    required BuildContext context,
  }) : super(context: context);

  @override
  Widget build() => ThemeBloc.widgetInterface.divider();
}

class PgSettingsItemPrivacy extends PgSettingsItem {
  PgSettingsItemPrivacy({required BuildContext context}) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.privacy;

  @override
  IconData? get getPrefixIconData => Icons.privacy_tip_outlined;

  @override
  VoidCallback get getOnTap => () => AppNavigation.push(
        context,
        MaterialPageRoute(
          builder: (_) => ThemeBloc.pageInterface.privacyPage(),
        ),
        () {},
      );
}

class PgSettingsItemNotifications extends PgSettingsItem {
  PgSettingsItemNotifications({required BuildContext context}) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.notifications;

  @override
  IconData? get getPrefixIconData => Icons.notifications_outlined;

  @override
  VoidCallback get getOnTap => () => AppNavigation.push(
        context,
        MaterialPageRoute(
          builder: (_) => ThemeBloc.pageInterface.notificationsPage(),
        ),
        () {},
      );
}

class PgSettingsItemTheme extends PgSettingsItem {
  PgSettingsItemTheme({required BuildContext context}) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.theme;

  @override
  IconData? get getPrefixIconData => Icons.color_lens_outlined;

  @override
  VoidCallback get getOnTap => () => AppNavigation.push(
        context,
        MaterialPageRoute(
          builder: (_) => ThemeBloc.pageInterface.themePage(),
        ),
        () {},
      );
}

class PgSettingsItemSecurity extends PgSettingsItem {
  PgSettingsItemSecurity({required BuildContext context}) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.security;

  @override
  IconData? get getPrefixIconData => Icons.security;

  @override
  VoidCallback get getOnTap => () => AppNavigation.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThemeBloc.pageInterface.securityPage(),
        ),
        () {},
      );
}

class PgSettingsItemPassword extends PgSettingsItem {
  PgSettingsItemPassword({required BuildContext context}) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.password;

  @override
  IconData? get getPrefixIconData => Icons.vpn_key_outlined;

  @override
  VoidCallback? get getOnTap => () => AppNavigation.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ThemeBloc.pageInterface.formEditorPage(
            screenTitle: AppLocalizations.of(context)!.password,
            screenDescription: '',
            formEditorType: FormEditorTypePassword(context: context),
          );
        }),
        () {},
      );
}

class PgSettingsAccountPrivacy extends PgSettingsItem {
  final VoidCallback onTap;

  PgSettingsAccountPrivacy({
    required BuildContext context,
    required this.onTap,
  }) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.privateAccount;

  @override
  VoidCallback? get getOnTap => onTap;

  @override
  IconData? get getPrefixIconData {
    var authedUserModel = AuthBloc.of(context).getCurrentUser;
    return authedUserModel.isPrivateAccount ? Icons.lock_outline : Icons.lock_open_outlined;
  }

  @override
  Widget build() {
    var authedUserModel = AuthBloc.of(context).getCurrentUser;

    return Padding(
      padding: getPadding,
      child: ListTile(
        leading: getPrefixIcon,
        title: Text(
          getTitle,
          style: getTextStyle,
        ),
        minLeadingWidth: 0,
        onTap: getOnTap,
        trailing: IgnorePointer(
          child: Switch(
            value: authedUserModel.isPrivateAccount,
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }
}

class PgSettingsNotificationsPauseAll extends PgSettingsItem {
  final VoidCallback onTap;

  PgSettingsNotificationsPauseAll({
    required BuildContext context,
    required this.onTap,
  }) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.pauseAll;

  @override
  VoidCallback? get getOnTap => onTap;

  @override
  Widget build() {
    var authedUserModel = AuthBloc.of(context).getCurrentUser;
    return Padding(
      padding: getPadding,
      child: ListTile(
        title: Text(
          getTitle,
          style: getTextStyle,
        ),
        minLeadingWidth: 0,
        onTap: getOnTap,
        trailing: IgnorePointer(
          child: Switch(
            value: authedUserModel.metaPushSettings.pauseAll == UserMetaPushSettingsDTO.valueOn,
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }
}

class PgSettingsNotificationPostLikesAndComments extends PgSettingsItem {
  PgSettingsNotificationPostLikesAndComments({required BuildContext context}) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.postsLikesAndComments;

  @override
  VoidCallback? get getOnTap => () => AppNavigation.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PgNotificationPostsLikesAndCommentsPage(),
        ),
        () {},
      );

  @override
  Widget build() {
    return Padding(
      padding: getPadding,
      child: ListTile(
        title: Text(getTitle, style: getTextStyle),
        minLeadingWidth: 0,
        onTap: getOnTap,
      ),
    );
  }
}

class PgSettingsNotificationPhotosOfYou extends PgSettingsItem {
  PgSettingsNotificationPhotosOfYou({required BuildContext context}) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.photosOfYou;

  @override
  VoidCallback? get getOnTap => () => AppNavigation.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PgNotificationPhotosOfYou(),
        ),
        () {},
      );

  @override
  Widget build() {
    return Padding(
      padding: getPadding,
      child: ListTile(
        title: Text(getTitle, style: getTextStyle),
        minLeadingWidth: 0,
        onTap: getOnTap,
      ),
    );
  }
}

class PgSettingsNotificationsFollowingAndFollowers extends PgSettingsItem {
  PgSettingsNotificationsFollowingAndFollowers({required BuildContext context}) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.followingAndFollowers;

  @override
  VoidCallback? get getOnTap => () => AppNavigation.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PgNotificationFollowingAndFollowersPage(),
        ),
        () {},
      );

  @override
  Widget build() {
    return Padding(
      padding: getPadding,
      child: ListTile(
        title: Text(getTitle, style: getTextStyle),
        minLeadingWidth: 0,
        onTap: getOnTap,
      ),
    );
  }
}

class PgSettingsItemBlockedAccounts extends PgSettingsItem {
  PgSettingsItemBlockedAccounts({required BuildContext context}) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.blockedAccounts;

  @override
  IconData? get getPrefixIconData => Icons.cancel_outlined;

  @override
  VoidCallback? get getOnTap => () => AppNavigation.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ThemeBloc.pageInterface.blockedAccountsPage();
        }),
        () {},
      );
}

class PgSettingsItemLogOut extends PgSettingsItem {
  PgSettingsItemLogOut({required BuildContext context}) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.logOut;

  @override
  Icon? get getPrefixIcon => null;

  @override
  TextStyle? get getTextStyle => ThemeBloc.getThemeData.primaryTextTheme.headline5;

  @override
  VoidCallback? get getOnTap => () => AppProvider.of(context).auth.pushEvent(AuthEventLogout(context));
}

class PgSettingsItemsPersonalInformationSettings extends PgSettingsItem {
  final int userId;

  PgSettingsItemsPersonalInformationSettings({
    required BuildContext context,
    required this.userId,
  }) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.personalInformation;

  @override
  Icon? get getPrefixIcon => null;

  @override
  TextStyle? get getTextStyle => ThemeBloc.getThemeData.primaryTextTheme.headline5;

  @override
  VoidCallback? get getOnTap => () => AppNavigation.push(
        context,
        MaterialPageRoute(
          builder: (_) => ThemeBloc.pageInterface.editPersonalInformationPage(userId: userId),
        ),
        () {},
      );
}

class PgSettingsItemEditProfile extends PgSettingsItem {
  final int userId;

  PgSettingsItemEditProfile({
    required BuildContext context,
    required this.userId,
  }) : super(context: context);

  @override
  String get getTitle => AppLocalizations.of(context)!.editProfile;

  @override
  Icon? get getPrefixIcon => null;

  @override
  TextStyle? get getTextStyle => ThemeBloc.getThemeData.primaryTextTheme.headline5;

  @override
  VoidCallback? get getOnTap => () => AppNavigation.push(
        context,
        MaterialPageRoute(
          builder: (_) => ThemeBloc.pageInterface.editProfilePage(userId: userId),
        ),
        () {},
      );
}
