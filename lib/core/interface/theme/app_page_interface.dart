import 'package:photogram/import/core.dart';

abstract class AppPageInterface {
  abstract ThemePageSignature themePage;

  abstract RegistrationPageSignature registrationPage;

  abstract FeedsPageSignature feedsPage;

  abstract ProfilePageSignature profilePage;

  abstract PostPageSignature postPage;

  abstract SearchPageSignature searchPage;

  abstract ActivityPageSignature activityPage;

  abstract HashtagPageSignature hashtagPage;

  abstract SecurityPageSignature securityPage;

  abstract PrivacyPageSignature privacyPage;

  abstract NotificationsPageSignature notificationsPage;

  abstract PendingFollowRequestsPageSignature pendingFollowRequestsPage;

  abstract CreatePostPageSignature createPostPage;

  abstract SettingsPageSignature settingsPage;

  abstract BlockedAccountsPageSignature blockedAccountsPage;

  abstract PostlikesPageSignature postLikesPage;

  abstract PostcommentsPageSignature postCommentsPage;

  abstract PostCommentLikesPageSignature postCommentLikesPage;

  abstract FormEditorPageSignature formEditorPage;

  abstract EditProfilePageSignature editProfilePage;

  abstract SearchPostsPageSignature searchPostsPage;

  abstract ProfileUserPostsPageSignature profileUserPostsPage;

  abstract ProfileUserTaggedInPostsPageSignature profileUserTaggedInPostsPage;

  abstract HashtagPostsPageSignature hashtagPostsPage;

  abstract CollectionsPageSignature collectionsPage;

  abstract CreateCollectionPageSignature createCollectionPage;

  abstract CollectionPostsPageSignature collectionPostsPage;

  abstract CollectionPostsPageFullSignature collectionPostsPageFull;

  abstract EditProfilePicturePageSignature editProfilePicturePage;

  abstract ProfileRelationshipsPageSignature profileRelationshipsPage;

  abstract EditPersonalInformationPageSignature editPersonalInformationPage;

  abstract RecoverAccountPageSignature recoverAccountPage;
}
