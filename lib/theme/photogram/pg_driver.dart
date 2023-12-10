import 'package:photogram/theme/photogram/photogram_theme.dart';
import 'package:photogram/theme/photogram/modules/pg_text_module.dart';
import 'package:photogram/theme/photogram/modules/pg_screen_module.dart';
import 'package:photogram/theme/photogram/modules/pg_widget_module.dart';
import 'package:photogram/theme/photogram/modules/pg_action_module.dart';
import 'package:photogram/theme/photogram/modules/pg_object_module.dart';
import 'package:photogram/theme/photogram/modules/pg_page_module.dart';
import 'package:photogram/theme/photogram/implementation/pg_text_implementation.dart';
import 'package:photogram/theme/photogram/implementation/pg_object_implementation.dart';
import 'package:photogram/theme/photogram/implementation/pg_page_implementation.dart';
import 'package:photogram/theme/photogram/implementation/pg_action_implementation.dart';
import 'package:photogram/theme/photogram/implementation/pg_screen_implementation.dart';
import 'package:photogram/theme/photogram/implementation/pg_widget_implementation.dart';

class PgDriver {
  PhotogramTheme photogramTheme;

  late PgTextModule textModule;
  late PgPageModule pageModule;
  late PgActionModule actionModule;
  late PgObjectModule objectModule;
  late PgScreenModule screenModule;
  late PgWidgetModule widgetModule;

  PgDriver(this.photogramTheme) {
    textModule = PgTextModule(photogramTheme);
    pageModule = PgPageModule(photogramTheme);
    objectModule = PgObjectModule(photogramTheme);
    actionModule = PgActionModule(photogramTheme);
    screenModule = PgScreenModule(photogramTheme);
    widgetModule = PgWidgetModule(photogramTheme);
  }

  PgActionImplementation implementActionInterface() => PgActionImplementation(
        openProfilePage: actionModule.openProfilePage,
        openEditProfilePage: actionModule.openEditProfilePage,
        showMessageInsidePopUp: actionModule.showMessageInsidePopUp,
      );

  PgObjectImplementation implementObjectInterface() => PgObjectImplementation(
        userAppTile: objectModule.userAppTile,
      );

  PgWidgetImplementation implementWidgetInterface() => PgWidgetImplementation(
        divider: widgetModule.divider,
        themeButton: widgetModule.themeButton,
        hollowButton: widgetModule.hollowButton,
        primaryTextField: widgetModule.primaryTextField,
        standardTextField: widgetModule.standardTextField,
      );

  PgScreenImplementation implementScreenInterface() => PgScreenImplementation(
        homeScreen: screenModule.homeScreen,
        loginScreen: screenModule.loginScreen,
        emailVerificationScreen: screenModule.emailVerificationScreen,
        noNetworkScreen: screenModule.noNetworkScreen,
        somethingWentWrongScreen: screenModule.somethingWentWrongScreen,
        splashScreen: screenModule.splashScreen,
        transitionScreen: screenModule.transitionScreen,
      );

  PgPageImplementation implementPageInterface() => PgPageImplementation(
        collectionPostsPage: pageModule.collectionPostsPage,
        registrationPage: pageModule.registrationPage,
        collectionPostsPageFull: pageModule.collectionPostsPageFull,
        collectionsPage: pageModule.collectionsPage,
        createCollectionPage: pageModule.createCollectionPage,
        editPersonalInformationPage: pageModule.editPersonalInformationPage,
        editProfilePage: pageModule.editProfilePage,
        editProfilePicturePage: pageModule.editProfilePicturePage,
        feedsPage: pageModule.feedsPage,
        activityPage: pageModule.activityPage,
        createPostPage: pageModule.createPostPage,
        formEditorPage: pageModule.formEditorPage,
        postLikesPage: pageModule.postLikesPage,
        postCommentsPage: pageModule.postCommentsPage,
        postCommentLikesPage: pageModule.postCommentLikesPage,
        searchPage: pageModule.searchPage,
        postPage: pageModule.postPage,
        profilePage: pageModule.profilePage,
        hashtagPage: pageModule.hashtagPage,
        searchPostsPage: pageModule.searchPostsPage,
        profileUserPostsPage: pageModule.profileUserPostsPage,
        profileUserTaggedInPostsPage: pageModule.profileUserTaggedInPostsPage,
        hashtagPostsPage: pageModule.hashtagPostsPage,
        profileRelationshipsPage: pageModule.profileRelationshipsPage,
        securityPage: pageModule.securityPage,
        privacyPage: pageModule.privacyPage,
        pendingFollowRequestsPage: pageModule.pendingFollowRequestsPage,
        notificationsPage: pageModule.notificationsPage,
        recoverAccountPage: pageModule.recoverAccountPage,
        blockedAccountsPage: pageModule.blockedAccountsPage,
        settingsPage: pageModule.settingsPage,
        themePage: pageModule.themePage,
      );

  PgTextImplementation implementTextInterface() => PgTextImplementation(
        boldBlackH1Text: textModule.boldBlackH1Text,
        boldBlackH2Text: textModule.boldBlackH2Text,
        boldBlackH3Text: textModule.boldBlackH3Text,
        boldBlackH4Text: textModule.boldBlackH4Text,
        boldBlackH5Text: textModule.boldBlackH5Text,
        boldBlackH6Text: textModule.boldBlackH6Text,
        normalBlackH1Text: textModule.normalBlackH1Text,
        normalBlackH2Text: textModule.normalBlackH2Text,
        normalBlackH3Text: textModule.normalBlackH3Text,
        normalBlackH4Text: textModule.normalBlackH4Text,
        normalBlackH5Text: textModule.normalBlackH5Text,
        normalBlackH6Text: textModule.normalBlackH6Text,
        normalGreyH1Text: textModule.normalGreyH1Text,
        normalGreyH2Text: textModule.normalGreyH2Text,
        normalGreyH3Text: textModule.normalGreyH3Text,
        normalGreyH4Text: textModule.normalGreyH4Text,
        normalGreyH5Text: textModule.normalGreyH5Text,
        normalGreyH6Text: textModule.normalGreyH6Text,
        normalHrefH1Text: textModule.normalHrefH1Text,
        normalHrefH2Text: textModule.normalHrefH2Text,
        normalHrefH3Text: textModule.normalHrefH3Text,
        normalHrefH4Text: textModule.normalHrefH4Text,
        normalHrefH5Text: textModule.normalHrefH5Text,
        normalHrefH6Text: textModule.normalHrefH6Text,
        normalThemeH1Text: textModule.normalThemeH1Text,
        normalThemeH2Text: textModule.normalThemeH2Text,
        normalThemeH3Text: textModule.normalThemeH3Text,
        normalThemeH4Text: textModule.normalThemeH4Text,
        normalThemeH5Text: textModule.normalThemeH5Text,
        normalThemeH6Text: textModule.normalThemeH6Text,
        boldBlackH1TextStyle: () => photogramTheme.modeImplementation.boldBlackH1,
        boldBlackH2TextStyle: () => photogramTheme.modeImplementation.boldBlackH2,
        boldBlackH3TextStyle: () => photogramTheme.modeImplementation.boldBlackH3,
        boldBlackH4TextStyle: () => photogramTheme.modeImplementation.boldBlackH4,
        boldBlackH5TextStyle: () => photogramTheme.modeImplementation.boldBlackH5,
        boldBlackH6TextStyle: () => photogramTheme.modeImplementation.boldBlackH6,
        normalBlackH1TextStyle: () => photogramTheme.modeImplementation.normalBlackH1,
        normalBlackH2TextStyle: () => photogramTheme.modeImplementation.normalBlackH2,
        normalBlackH3TextStyle: () => photogramTheme.modeImplementation.normalBlackH3,
        normalBlackH4TextStyle: () => photogramTheme.modeImplementation.normalBlackH4,
        normalBlackH5TextStyle: () => photogramTheme.modeImplementation.normalBlackH5,
        normalBlackH6TextStyle: () => photogramTheme.modeImplementation.normalBlackH6,
        normalGreyH1TextStyle: () => photogramTheme.modeImplementation.normalGreyH1,
        normalGreyH2TextStyle: () => photogramTheme.modeImplementation.normalGreyH2,
        normalGreyH3TextStyle: () => photogramTheme.modeImplementation.normalGreyH3,
        normalGreyH4TextStyle: () => photogramTheme.modeImplementation.normalGreyH4,
        normalGreyH5TextStyle: () => photogramTheme.modeImplementation.normalGreyH5,
        normalGreyH6TextStyle: () => photogramTheme.modeImplementation.normalGreyH6,
        normalHrefH1TextStyle: () => photogramTheme.modeImplementation.normalHrefH1,
        normalHrefH2TextStyle: () => photogramTheme.modeImplementation.normalHrefH2,
        normalHrefH3TextStyle: () => photogramTheme.modeImplementation.normalHrefH3,
        normalHrefH4TextStyle: () => photogramTheme.modeImplementation.normalHrefH4,
        normalHrefH5TextStyle: () => photogramTheme.modeImplementation.normalHrefH5,
        normalHrefH6TextStyle: () => photogramTheme.modeImplementation.normalHrefH6,
        normalThemeH1TextStyle: () => photogramTheme.modeImplementation.normalThemeH1,
        normalThemeH2TextStyle: () => photogramTheme.modeImplementation.normalThemeH2,
        normalThemeH3TextStyle: () => photogramTheme.modeImplementation.normalThemeH3,
        normalThemeH4TextStyle: () => photogramTheme.modeImplementation.normalThemeH4,
        normalThemeH5TextStyle: () => photogramTheme.modeImplementation.normalThemeH5,
        normalThemeH6TextStyle: () => photogramTheme.modeImplementation.normalThemeH6,
      );
}
