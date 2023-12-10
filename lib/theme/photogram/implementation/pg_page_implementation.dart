import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';

class PgPageImplementation extends AppPageInterface {
  PgPageImplementation({
    required this.registrationPage,
    required this.collectionPostsPage,
    required this.collectionPostsPageFull,
    required this.collectionsPage,
    required this.createCollectionPage,
    required this.editPersonalInformationPage,
    required this.editProfilePage,
    required this.editProfilePicturePage,
    required this.feedsPage,
    required this.activityPage,
    required this.formEditorPage,
    required this.postLikesPage,
    required this.postCommentsPage,
    required this.postCommentLikesPage,
    required this.profilePage,
    required this.createPostPage,
    required this.searchPage,
    required this.postPage,
    required this.hashtagPage,
    required this.searchPostsPage,
    required this.profileUserPostsPage,
    required this.profileUserTaggedInPostsPage,
    required this.hashtagPostsPage,
    required this.profileRelationshipsPage,
    required this.securityPage,
    required this.privacyPage,
    required this.notificationsPage,
    required this.pendingFollowRequestsPage,
    required this.recoverAccountPage,
    required this.settingsPage,
    required this.blockedAccountsPage,
    required this.themePage,
  });

  @override
  RegistrationPageSignature registrationPage;

  @override
  EditPersonalInformationPageSignature editPersonalInformationPage;

  @override
  EditProfilePageSignature editProfilePage;

  @override
  EditProfilePicturePageSignature editProfilePicturePage;

  @override
  FeedsPageSignature feedsPage;

  @override
  ActivityPageSignature activityPage;

  @override
  PostPageSignature postPage;

  @override
  CreatePostPageSignature createPostPage;

  @override
  PendingFollowRequestsPageSignature pendingFollowRequestsPage;

  @override
  FormEditorPageSignature formEditorPage;

  @override
  PostlikesPageSignature postLikesPage;

  @override
  PostcommentsPageSignature postCommentsPage;

  @override
  PostCommentLikesPageSignature postCommentLikesPage;

  @override
  ProfilePageSignature profilePage;

  @override
  HashtagPageSignature hashtagPage;

  @override
  ProfileUserPostsPageSignature profileUserPostsPage;

  @override
  HashtagPostsPageSignature hashtagPostsPage;

  @override
  ProfileRelationshipsPageSignature profileRelationshipsPage;

  @override
  SecurityPageSignature securityPage;

  @override
  PrivacyPageSignature privacyPage;

  @override
  NotificationsPageSignature notificationsPage;

  @override
  SettingsPageSignature settingsPage;

  @override
  ThemePageSignature themePage;

  @override
  CollectionPostsPageSignature collectionPostsPage;

  @override
  CollectionPostsPageFullSignature collectionPostsPageFull;

  @override
  BlockedAccountsPageSignature blockedAccountsPage;

  @override
  CollectionsPageSignature collectionsPage;

  @override
  CreateCollectionPageSignature createCollectionPage;

  @override
  RecoverAccountPageSignature recoverAccountPage;

  @override
  ProfileUserTaggedInPostsPageSignature profileUserTaggedInPostsPage;

  @override
  SearchPageSignature searchPage;

  @override
  SearchPostsPageSignature searchPostsPage;
}
