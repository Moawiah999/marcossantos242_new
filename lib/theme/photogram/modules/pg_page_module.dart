import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pages/others/recovery/pg_recover_account_page.dart';

import 'package:photogram/theme/photogram/photogram_theme.dart';

import 'package:photogram/theme/photogram/include/pages/activity/pg_activity_page.dart';
import 'package:photogram/theme/photogram/include/pages/hashtag/pg_hashtag_posts_page.dart';
import 'package:photogram/theme/photogram/include/pages/hashtag/pg_hashtag_page.dart';
import 'package:photogram/theme/photogram/include/pages/others/pg_registration_page.dart';
import 'package:photogram/theme/photogram/include/pages/notification/pg_pending_follow_requests_page.dart';
import 'package:photogram/theme/photogram/include/pages/post/create/pg_create_post_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/settings/pg_blocked_accounts_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/settings/pg_notifications_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/settings/pg_post_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/settings/pg_privacy_page.dart';
import 'package:photogram/theme/photogram/include/pages/search/pg_search_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/pg_profile_user_tagged_in_posts_page.dart';
import 'package:photogram/theme/photogram/include/pages/search/pg_search_posts_page.dart';

import 'package:photogram/theme/photogram/include/pages/post/pg_post_comment_likes_page.dart';
import 'package:photogram/theme/photogram/include/pages/post/pg_post_comments_page_wrap.dart';
import 'package:photogram/theme/photogram/include/pages/profile/collections/pg_collection_posts_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/collections/pg_collection_posts_page_full.dart';
import 'package:photogram/theme/photogram/include/pages/profile/collections/pg_collections_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/collections/pg_create_collection_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/edit/pg_form_editor_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/pg_profile_user_posts_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/pg_profile_relationships_page.dart';
import 'package:photogram/theme/photogram/include/pages/pg_feeds_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/settings/pg_profile_page.dart';
import 'package:photogram/theme/photogram/include/pages/post/pg_post_likes_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/edit/pg_edit_personal_information_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/edit/pg_edit_profile_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/edit/pg_edit_profile_picture_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/settings/pg_security_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/settings/pg_settings_page.dart';
import 'package:photogram/theme/photogram/include/pages/profile/pg_theme_page.dart';

class PgPageModule {
  PhotogramTheme photogramTheme;
  PgPageModule(this.photogramTheme);

  FeedsPage feedsPage({Key? key}) => PgFeedsPage(key: key);

  ActivityPage activityPage({Key? key}) => PgActivityPage(key: key);

  RegistrationPage registrationPage({Key? key}) => PgRegistrationPage(key: key);

  RecoverAccountPage recoverAccountPage({Key? key}) => PgRecoverAccountPage(key: key);

  ThemePage themePage({Key? key}) => PgThemePage(key: key);

  PostPage postPage({Key? key, required int postId}) => PgPostPage(key: key, postId: postId);

  SecurityPage securityPage({Key? key}) => PgSecurityPage(key: key);

  PendingFollowRequestsPage pendingFollowRequestsPage({Key? key}) => PgPendingFollowRequestsPage(key: key);

  BlockedAccountsPage blockedAccountsPage({Key? key}) => PgBlockedAccountsPage(key: key);

  PrivacyPage privacyPage({Key? key}) => PgPrivacyPage(key: key);

  NotificationsPage notificationsPage({Key? key}) => PgNotificationsPage(key: key);

  SearchPage searchPage({Key? key}) => PgSearchPage(key: key);

  ProfilePage profilePage({Key? key, required int userId}) => PgProfilePage(key: key, userId: userId);

  HashtagPage hashtagPage({
    Key? key,
    required int hashtagId,
    required String hashtag,
  }) =>
      PgHashtagPage(key: key, hashtagId: hashtagId, hashtag: hashtag);

  SettingsPage settingsPage({Key? key, required int userId}) => PgSettingsPage(key: key, userId: userId);

  PostlikesPage postLikesPage({Key? key, required int postId}) => PgPostLikesPage(key: key, postId: postId);

  PostcommentsPage postCommentsPage({Key? key, required int postId, required bool focus}) =>
      PgPostCommentsPageWrap(key: key, postId: postId, focus: focus);

  PostCommentLikesPage postCommentLikesPage({Key? key, required int postCommentId}) =>
      PgPostCommentLikesPage(key: key, postCommentId: postCommentId);

  EditProfilePage editProfilePage({Key? key, required int userId}) => PgEditProfilePage(key: key, userId: userId);

  EditProfilePicturePage editProfilePicturePage({Key? key, required XFile pickedImage}) =>
      PgEditProfilePicturePage(key: key, pickedImage: pickedImage);

  EditPersonalInformationPage editPersonalInformationPage({Key? key, required int userId}) =>
      PgEditPersonalInformationPage(key: key, userId: userId);

  ProfileRelationshipsPage profileRelationshipsPage({
    Key? key,
    required int userId,
    required bool typeFollowers,
  }) =>
      PgProfileRelationshipsPage(
        key: key,
        userId: userId,
        typeFollowers: typeFollowers,
      );

  FormEditorPage formEditorPage({
    Key? key,
    required String screenTitle,
    required String screenDescription,
    required FormEditorType formEditorType,
  }) =>
      PgFormEditorPage(
        screenTitle: screenTitle,
        formEditorType: formEditorType,
        screenDescription: screenDescription,
      );

  CreatePostPage createPostPage({Key? key}) => PgCreatePostPage(key: key);

  SearchPostsPage searchPostsPage({
    Key? key,
    required List<int> postIds,
    required int scrollToPostIndex,
  }) =>
      PgSearchPostsPage(
        postIds: postIds,
        scrollToPostIndex: scrollToPostIndex,
      );

  ProfileUserPostsPage profileUserPostsPage({
    Key? key,
    required int userId,
    required List<int> postIds,
    required int scrollToPostIndex,
  }) =>
      PgProfileUserPostsPage(
        userId: userId,
        postIds: postIds,
        scrollToPostIndex: scrollToPostIndex,
      );

  ProfileUserTaggedInPostsPage profileUserTaggedInPostsPage({
    Key? key,
    required int userId,
    required List<int> postUserTagIds,
    required int scrollToPostUserTagIndex,
  }) =>
      PgProfileUserTaggedInPostsPage(
        userId: userId,
        postUserTagIds: postUserTagIds,
        scrollToPostUserTagIndex: scrollToPostUserTagIndex,
      );

  HashtagPostsPage hashtagPostsPage({
    Key? key,
    required int hashtagId,
    required String hashtag,
    required List<int> hashtagPostIds,
    required int scrollToPostIndex,
  }) =>
      PgHashtagPostsPage(
        hashtag: hashtag,
        hashtagId: hashtagId,
        hashtagPostIds: hashtagPostIds,
        scrollToPostIndex: scrollToPostIndex,
      );

  CollectionPostsPage collectionPostsPage({
    Key? key,
    required int collectionId,
    required String defaultAppBarTitle,
  }) =>
      PgCollectionPostsPage(
        key: key,
        collectionId: collectionId,
        defaultAppBarTitle: defaultAppBarTitle,
      );

  CollectionPostsPageFull collectionPostsPageFull({
    Key? key,
    required int collectionId,
    required List<int> postSaveIds,
    required String defaultAppBarTitle,
    required int scrollToPostSaveIndex,
  }) =>
      PgCollectionPostsPageFull(
        key: key,
        collectionId: collectionId,
        postSaveIds: postSaveIds,
        scrollToPostSaveIndex: scrollToPostSaveIndex,
        defaultAppBarTitle: defaultAppBarTitle,
      );

  CollectionsPage collectionsPage({Key? key}) => PgCollectionsPage(key: key);

  CreateCollectionPage createCollectionPage({Key? key}) => PgCreateCollectionPage(key: key);
}
