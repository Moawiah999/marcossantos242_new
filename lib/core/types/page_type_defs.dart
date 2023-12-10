///
/// this might appear messy at first but it's not.
/// since it's very difficult to test a third-party theme we'are enforcing entire app page's interface
/// to make sure that a third party theme has to implement atleast all pages and it gives certain quality
/// insights about a third party theme right-away
///

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/interface.dart';

typedef FeedsPageSignature = FeedsPage Function({Key? key});

typedef ThemePageSignature = ThemePage Function({Key? key});

typedef SecurityPageSignature = SecurityPage Function({Key? key});

typedef PrivacyPageSignature = PrivacyPage Function({Key? key});

typedef NotificationsPageSignature = NotificationsPage Function({Key? key});

typedef BlockedAccountsPageSignature = BlockedAccountsPage Function({Key? key});

typedef SearchPageSignature = SearchPage Function({Key? key});

typedef ProfilePageSignature = ProfilePage Function({Key? key, required int userId});

typedef PendingFollowRequestsPageSignature = PendingFollowRequestsPage Function({Key? key});

typedef PostPageSignature = PostPage Function({Key? key, required int postId});

typedef RegistrationPageSignature = RegistrationPage Function({Key? key});

typedef RecoverAccountPageSignature = RecoverAccountPage Function({Key? key});

typedef CreatePostPageSignature = CreatePostPage Function({Key? key});

typedef SettingsPageSignature = SettingsPage Function({Key? key, required int userId});

typedef PostlikesPageSignature = PostlikesPage Function({Key? key, required int postId});

typedef PostcommentsPageSignature = PostcommentsPage Function({Key? key, required int postId, required bool focus});

typedef PostCommentLikesPageSignature = PostCommentLikesPage Function({Key? key, required int postCommentId});

typedef EditProfilePageSignature = EditProfilePage Function({Key? key, required int userId});

typedef EditProfilePicturePageSignature = EditProfilePicturePage Function({Key? key, required XFile pickedImage});

typedef EditPersonalInformationPageSignature = EditPersonalInformationPage Function({Key? key, required int userId});

typedef ActivityPageSignature = ActivityPage Function({Key? key});

typedef CollectionsPageSignature = CollectionsPage Function({Key? key});

typedef CreateCollectionPageSignature = CreateCollectionPage Function({Key? key});

typedef ProfileRelationshipsPageSignature = ProfileRelationshipsPage Function({
  Key? key,
  required int userId,
  required bool typeFollowers,
});

typedef HashtagPageSignature = HashtagPage Function({
  Key? key,
  required int hashtagId,
  required String hashtag,
});

typedef FormEditorPageSignature = FormEditorPage Function({
  Key? key,
  required String screenTitle,
  required String screenDescription,
  required FormEditorType formEditorType,
});

typedef ProfileUserPostsPageSignature = ProfileUserPostsPage Function({
  Key? key,
  required int userId,
  required List<int> postIds,
  required int scrollToPostIndex,
});

typedef SearchPostsPageSignature = SearchPostsPage Function({
  Key? key,
  required List<int> postIds,
  required int scrollToPostIndex,
});

typedef ProfileUserTaggedInPostsPageSignature = ProfileUserTaggedInPostsPage Function({
  Key? key,
  required int userId,
  required List<int> postUserTagIds,
  required int scrollToPostUserTagIndex,
});

typedef HashtagPostsPageSignature = HashtagPostsPage Function({
  Key? key,
  required int hashtagId,
  required String hashtag,
  required List<int> hashtagPostIds,
  required int scrollToPostIndex,
});

typedef CollectionPostsPageSignature = CollectionPostsPage Function({
  Key? key,
  required int collectionId,
  required String defaultAppBarTitle,
});

typedef CollectionPostsPageFullSignature = CollectionPostsPageFull Function({
  Key? key,
  required int collectionId,
  required List<int> postSaveIds,
  required String defaultAppBarTitle,
  required int scrollToPostSaveIndex,
});
