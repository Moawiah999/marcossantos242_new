import 'package:flutter/material.dart';

class KeyGen {
  KeyGen._();

  static Key from(AppWidgetKey key) => Key(key.toString());
}

enum AppWidgetKey {
  appScreen,

  feedsPageHomeScreenBottomNavItem,
  searchPageHomeScreenBottomNavItem,
  addPostPageHomeScreenBottomNavItem,
  favoritePageHomeScreenBottomNavItem,
  profilePageHomeScreenBottomNavItem,

  usernameLoginScreenTextField,
  passwordLoginScreenTextField,

  emailRegisterPageTextField,
  usernameRegisterPageTextField,
  passwordRegisterPageTextField,

  addCommentPostCommentsPageTextField,

  loginLoginScreenButton,
  signUpRegistrationPageButton,

  splashScreen,
  loginScreen,
  homeScreen,
  emailVerificationScreen,
  noNetworkScreen,
  somethingWentWrongScreen,

  missingFieldsLoginScreenMessageDialog,
  nonExistingUserLoginScreenMessageDialog,
  incorrectUserCredentialsLoginScreenMessageDialog,
  okMessageDialog,
  cancelMessageDialog,

  editProfileProfilePageButton,

  displayNameProfilePageFieldView,
  usernameProfilePageFieldView,
  displayBioProfilePageFieldView,
  displayWebProfilePageFieldView,
  emailProfilePageFieldView,

  personalInformationEditProfilePageHref,

  displayNameProfilePageTextField,
  usernameProfilePageTextField,
  displayBioProfilePageTextField,
  displayWebProfilePageTextField,
  emailProfilePageTextField,
  currentPasswordProfilePageTextField,
  newPasswordProfilePageTextField,
  retypeNewPasswordProfilePageTextField,

  saveFormEditorPageIcon,
  backFormEditorPageIcon,

  saveEditProfilePageIcon,
  backEditProfilePageIcon,

  saveEditPersonalInformationPageIcon,
  backEditPersonalInformationPageIcon,

  rootFeedsPage,
  rootSearchPage,
  rootActivityPage,
  rootProfilePage,
}
