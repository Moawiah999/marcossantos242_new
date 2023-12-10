import 'package:flutter/material.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

mixin AppUserMixin<T extends StatefulWidget> on State<T> {
  /*
  |--------------------------------------------------------------------------
  | common functions for user:
  |--------------------------------------------------------------------------
  */

  Widget userMixinBuildUserTile(UserModel userModel) {
    var userTile = ThemeBloc.objectInterface.userAppTile(userModel: userModel);
    userTile.onTap = () => AppNavigation.push(
          context,
          MaterialPageRoute(
            builder: (_) => ThemeBloc.pageInterface.profilePage(userId: userModel.intId),
          ),
          () => setState(() {}),
        );

    userTile.trailing = userMixinBuildRelationshipButton(userModel: userModel);

    return userTile.dispense();
  }

  Widget userMixinBuildRelationshipButton({
    Key? key,
    required UserModel userModel,
    AppButtonProperties size = AppButtonProperties.standard,
  }) {
    String buttonText;
    ButtonWidgetSignature buttonType;
    Function buttonOnTapCallback;

    if (userModel.isLoggedIn) {
      /*
      |--------------------------------------------------------------------------
      | edit profile button:
      |--------------------------------------------------------------------------
      */
      buttonText = AppLocalizations.of(context)!.editProfile;
      buttonType = AppUtils.button(AppButtonProperties.hollow, size);

      buttonOnTapCallback = () => ThemeBloc.actionInterface.openEditProfilePage(
            buildContext: context,
            userId: userModel.intId,
            refreshCallback: () => setState(() {}),
          );
    } else if (userModel.isBlockedByCurrentUser) {
      /*
      |--------------------------------------------------------------------------
      | unblock button:
      |--------------------------------------------------------------------------
      */
      buttonText = AppLocalizations.of(context)!.unblock;
      buttonType = AppUtils.button(AppButtonProperties.hollow, size);

      buttonOnTapCallback = () => userMixinBlockUser(userModel, false);
    } else if (userModel.isFollowedByCurrentUser) {
      /*
      |--------------------------------------------------------------------------
      | following/requested button:
      |--------------------------------------------------------------------------
      */
      buttonText = userModel.isFollowRequestPending
          ? AppLocalizations.of(context)!.requested
          : AppLocalizations.of(context)!.following;

      buttonType = AppUtils.button(AppButtonProperties.hollow, size);

      buttonOnTapCallback = () => userMixinFollowUser(userModel, false);
    } else {
      /*
      |--------------------------------------------------------------------------
      | follow/request button:
      |--------------------------------------------------------------------------
      */
      buttonText = userModel.isPrivateAccount
          ? AppLocalizations.of(context)!.request
          : AppLocalizations.of(context)!.follow;
      buttonType = AppUtils.button(
          userModel.isPrivateAccount ? AppButtonProperties.hollow : AppButtonProperties.theme, size);

      buttonOnTapCallback = () => userMixinFollowUser(userModel, true);
    }

    return buttonType(
      key: userModel.isLoggedIn ? KeyGen.from(AppWidgetKey.editProfileProfilePageButton) : key,
      text: buttonText,
      onTapCallback: buttonOnTapCallback,
    );
  }

  void userMixinFollowUser(UserModel userModel, [bool doFollow = true]) async {
    // update widget
    setState(() {
      userModel.setFollowedByCurrentUser(doFollow);
    });

    // do request
    var responseResult =
        await AppProvider.of(context).apiRepo.userFollowActionAdd(doFollow: doFollow, userModel: userModel);

    if (!responseResult) {
      // something went wrong, revert changes
      setState(() {
        userModel.setFollowedByCurrentUser(!doFollow);
      });
    }
  }

  void userMixinBlockUser(UserModel userModel, [bool doBlock = true]) async {
    // update widget
    setState(() {
      userModel.setBlockedByCurrentUser(doBlock);
    });

    // do request
    var responseResult =
        await AppProvider.of(context).apiRepo.userBlockActionAdd(doBlock: doBlock, userModel: userModel);

    if (!responseResult) {
      // something went wrong, revert changes
      setState(() {
        userModel.setBlockedByCurrentUser(!doBlock);
      });
    }
  }

  void userMixinSetAccountPrivacy(String metaIsPrivate) async {
    var authedUserModel = AuthBloc.of(context).getCurrentUser;

    // update widget
    setState(() {
      authedUserModel.setAccountPrivacy(metaIsPrivate);
    });

    // do request
    var responseResult =
        await AppProvider.of(context).apiRepo.userUpdateAccountPrivacy(metaIsPrivate: metaIsPrivate);

    if (!responseResult) {
      // something went wrong, revert changes
      setState(() {
        authedUserModel.unsetAccountPrivacy(metaIsPrivate);
      });
    }
  }
}
