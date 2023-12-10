// ignore_for_file: constant_identifier_names

import 'package:photogram/import/data.dart';

/*
|--------------------------------------------------------------------------
| Request enums:
|--------------------------------------------------------------------------
*/

const METHOD_GET = 'GET';

const METHOD_POST = 'POST';

/*
|--------------------------------------------------------------------------
| user
|--------------------------------------------------------------------------
*/

// session

const REQ_TYPE_SESSION = 'session';

const REQ_TYPE_LOGIN = 'login';

const REQ_TYPE_LOGOUT = 'logout';

const REQ_TYPE_REGISTER = 'register';

// update user fields

const REQ_TYPE_UPDATE_USER_DISPLAY_NAME = 'update_user_display_name';

const REQ_TYPE_UPDATE_USER_USERNAME = 'update_user_username';

const REQ_TYPE_UPDATE_USER_DISPLAY_BIO = 'update_user_display_bio';

const REQ_TYPE_UPDATE_USER_DISPLAY_WEB = 'update_user_display_web';

const REQ_TYPE_UPDATE_USER_EMAIL = 'update_user_email';

const REQ_TYPE_UPDATE_USER_PASSWORD = 'update_user_password';

/// __requires_
/// * [UserTable.metaPushSettings]
///
/// __returns__
///
/// * [UserModel]
///
const REQ_TYPE_UPDATE_USER_META_PUSH_SETTINGS = 'update_user_meta_push_settings';

/// __requires_
/// * [UserTable.metaIsPrivate]
///     - [UserEnum.metaIsPrivateYes] sets account privacy to private
///     - [UserEnum.metaIsPrivateNo] sets account privacy to public
///
/// __returns__
///
/// * [UserModel]
///
const REQ_TYPE_UPDATE_USER_META_IS_PRIVATE = 'update_user_meta_is_private';

const REQ_TYPE_REMOVE_USER_PROFILE_PICTURE = 'remove_user_profile_picture';

const REQ_TYPE_UPLOAD_USER_PROFILE_PICTURE = 'upload_user_profile_picture';

// content

/// __requires_
/// * [UserTable.displayName] - search string
///
/// optional
/// * [UserTable.id] - offset
///
/// __returns__
///
/// * [UserModel]
///
/// additional returns
/// * [UserFollowModel]
///
const REQ_TYPE_USER_GLOBAL_SEARCH_LATEST = 'user_global_search_latest';

/// see [REQ_TYPE_USER_GLOBAL_SEARCH_LATEST] for more information
const REQ_TYPE_USER_GLOBAL_SEARCH_BOTTOM = 'user_global_search_bottom';

/// __requires_
/// * [UserTable.id] - id of user to fetch
///   or
/// * [UserTable.username] - username of user
///
/// __returns__
///
/// * [UserModel]
///
/// additional returns
/// * [UserFollowModel]
/// * [UserBlockModel]
///
const REQ_TYPE_USER_LOAD_SINGLE = 'user_load_single';

/*
|--------------------------------------------------------------------------
| user follow
|--------------------------------------------------------------------------
*/

// content

/// __requires__
/// * [UserTable.id] - id of user whos relationships are requested
///
/// optional
/// * [UserFollowTable.id] - offset
///
/// __returns__
///
/// * [UserFollowModel]
/// * [UserModel]
///
/// additional returns
/// * [UserFollowModel] whether current user following [UserModel] returned above
///
const REQ_TYPE_USER_FOLLOW_PROFILE_FOLLOWERS_LOAD_LATEST = 'user_follow_profile_followers_load_latest';

/// see [REQ_TYPE_USER_FOLLOW_PROFILE_FOLLOWERS_LOAD_LATEST] for more information
const REQ_TYPE_USER_FOLLOW_PROFILE_FOLLOWERS_LOAD_BOTTOM = 'user_follow_profile_followers_load_bottom';

/// __requires__
/// * [UserTable.id] - id of user whos relationships are requested
///
/// optional
/// * [UserFollowTable.id] - offset
///
/// __returns__
///
/// * [UserFollowModel]
/// * [UserModel]
///
/// additional returns
/// * [UserFollowModel] whether current user following [UserModel] returned above
///
const REQ_TYPE_USER_FOLLOW_PROFILE_FOLLOWINGS_LOAD_LATEST = 'user_follow_profile_followings_load_latest';

/// see [REQ_TYPE_USER_FOLLOW_PROFILE_FOLLOWINGS_LOAD_LATEST] for more information
const REQ_TYPE_USER_FOLLOW_PROFILE_FOLLOWINGS_LOAD_BOTTOM = 'user_follow_profile_followings_load_bottom';

/// __requires__
/// optional
/// * [UserFollowTable.id] - offset
///
/// __returns__
///
/// * [UserFollowModel]
/// * [UserModel]
///
/// additional returns
/// * [UserFollowModel] whether current user following [UserModel] returned above
///
const REQ_TYPE_USER_FOLLOW_PENDING_LOAD_LATEST = 'user_follow_pending_load_latest';

/// see [REQ_TYPE_USER_FOLLOW_PENDING_LOAD_LATEST] for more information
const REQ_TYPE_USER_FOLLOW_PENDING_LOAD_BOTTOM = 'user_follow_pending_load_bottom';

/// returns pending follow requests count + one latest user from pending
/// __returns__
///
/// * [NotificationsCountDTO]
/// * [UserModel] - the most recent user whos request is pending
///
const REQ_TYPE_USER_FOLLOW_PENDING_COUNT_AND_RECENT = 'user_follow_pending_count_and_recent';

// actions

/// __requires__
/// * [UserTable.id] - id of user to follow
///
/// __returns__
///
/// * [UserFollowModel]
/// * [UserModel]
///
const REQ_TYPE_USER_FOLLOW_ADD = 'user_follow_add';

/// __requires__
/// * [UserTable.id] - id of user to unfollow
///
/// __returns__
/// Success message if succeed
///
const REQ_TYPE_USER_FOLLOW_REMOVE = 'user_follow_remove';

/// __requires__
/// * [UserFollowTable.id] - follow id to accept
///
/// __returns__
/// [UserFollowModel]
/// & Success message if succeed
///
const REQ_TYPE_USER_FOLLOW_ACCEPT = 'user_follow_accept';

/// __requires__
/// * [UserFollowTable.id] - follow id to ignore
///
/// __returns__
/// Success message if succeed
///
const REQ_TYPE_USER_FOLLOW_IGNORE = 'user_follow_ignore';

/*
|--------------------------------------------------------------------------
| user block
|--------------------------------------------------------------------------
*/

/// optional
/// * [UserBlockTable.id] - offset
///
/// __returns__
///
/// * [UserModel]
/// * [UserBlockModel]
///
/// additional returns
/// * [UserBlockModel]
///
const REQ_TYPE_USER_BLOCK_LOAD_LATEST = 'user_block_load_latest';

/// see [REQ_TYPE_USER_BLOCK_LOAD_LATEST] for more information
const REQ_TYPE_USER_BLOCK_LOAD_BOTTOM = 'user_block_load_bottom';

/// __requires__
/// * [UserTable.id] - id of user to block
///
/// __returns__
///
/// * [UserBlockModel]
/// * [UserModel] - user that got blocked/or unblocked
///
const REQ_TYPE_USER_BLOCK_ADD = 'user_block_add';

/// __requires__
/// * [UserTable.id] - id of user to unblock
///
/// __returns__
/// Success message if succeed
///
const REQ_TYPE_USER_BLOCK_REMOVE = 'user_block_remove';

/*
|--------------------------------------------------------------------------
| user recovery
|--------------------------------------------------------------------------
*/

/// __requires__
/// * [UserTable.id] - id user to start recovery for
///
/// __returns__
/// [UserRecoveryModel] - containing id of recovery request which should be used in
/// next step i.e submitting and confirming otp
///
const REQ_TYPE_USER_RECOVERY_START = 'user_recovery_start';

/// __requires__
/// * [UserRecoveryTable.id] - reference id of active recovery request, client
///   can get one using [REQ_TYPE_USER_RECOVERY_START]
/// * [UserRecoveryTable.metaAccessOTP] - otp that client received in their email
///
/// __returns__
/// [UserRecoveryModel] - containing access token that user can use to
/// use to issue a password reset request
///
const REQ_TYPE_USER_RECOVERY_CONFIRM = 'user_recovery_confirm';

/// __requires__
/// * [UserRecoveryTable.id] - reference id of recovery request
/// * [UserRecoveryTable.metaAccessToken] - token that client get after otp confirmation
/// * [UserTable.extraNewPassword] - new password to set
/// * [UserTable.extraRetypeNewPassword] - new password retyped- we don't even trust client implementation
/// for such small validation xD
///
/// __returns__
/// [UserModel] logged in
///
const REQ_TYPE_USER_RECOVERY_RESET_PASSWORD = 'user_recovery_reset_password';

/*
|--------------------------------------------------------------------------
| user email verification
|--------------------------------------------------------------------------
*/

/// __requires__
/// * [UserTable.id] - id user that want to verify their email address
///
/// __returns__
/// [UserEmailVerificationModel] - containing id of verification request which should be used in
/// next step i.e submitting and confirming otp
///
const REQ_TYPE_USER_EMAIL_VERIFICATION_START = 'user_email_verification_start';

/// __requires__
/// * [UserEmailVerificationTable.id] - reference id of active verification request, client
///   can get one using [REQ_TYPE_USER_EMAIL_VERIFICATION_START]
/// * [UserEmailVerificationTable.metaAccessOTP] - otp that client received in their email
///
/// __returns__
/// success message if email is verified
///
const REQ_TYPE_USER_EMAIL_VERIFICATION_CONFIRM = 'user_email_verification_confirm';

/*
|--------------------------------------------------------------------------
| post
|--------------------------------------------------------------------------
*/

/// __requires_
/// * [PostTable.id] - id of post to fetch
///
/// __returns__
///
/// * [PostModel]
///
/// additional returns
/// * [PostLikeModel]
/// * [PostSaveModel]
///
const REQ_TYPE_POST_LOAD_SINGLE = 'post_load_single';

/// optional
/// * [PostTable.id] - offset
///
/// __returns__
///
/// * [PostModel]
/// * [UserModel]
///
/// additional returns
/// * [PostLikeModel]
/// * [PostSaveModel]
/// * [UserFollowModel]
///
const REQ_TYPE_POST_GLOBAL_FEED_LOAD_LATEST = 'post_global_feed_load_latest';

/// see [REQ_TYPE_POST_GLOBAL_FEED_LOAD_LATEST] for more information
const REQ_TYPE_POST_GLOBAL_FEED_LOAD_BOTTOM = 'post_global_feed_load_bottom';

/// __requires__
/// * [PostTable.ownerUserId] - fetch posts that belongs to user id
///
/// optional
/// * [PostTable.id] - offset
///
/// __returns__
///
/// * [PostModel]
/// * [UserModel]
///
/// additional returns
/// * [PostLikeModel]
/// * [PostSaveModel]
///
const REQ_TYPE_POST_USER_FEED_LOAD_LATEST = 'post_user_feed_load_latest';

/// see [REQ_TYPE_POST_USER_FEED_LOAD_LATEST] for more information
const REQ_TYPE_POST_USER_FEED_LOAD_BOTTOM = 'post_user_feed_load_bottom';

// infinite content, privacy enabled !

/// optional
/// * [PostTable.id] - offset
///
/// __returns__
///
/// * [PostModel]
/// * [UserModel]
///
/// additional returns
/// * [PostLikeModel]
/// * [PostSaveModel]
/// * [UserFollowModel]
///
const REQ_TYPE_POST_INFINITE_LOAD = 'post_infinite_load';

// actions

/// __requires__
/// * [PostTable.displayCaption] - Post display caption as string
/// * [PostTable.displayLocation] - Post location as string
/// * [PostTable.displayContent] - Contains map<imageId: list of user tags on that image>
/// * [PostTable.displayContent] As attachement - list of post display content item
///
/// __returns__
///
/// * [PostModel]
/// * [UserModel]
///
const REQ_TYPE_POST_ADD = 'post_add';

/// __requires__
/// * [PostTable.id] - id of the post to remove
///
/// __returns__
/// Success message if succeed
///
const REQ_TYPE_POST_REMOVE = 'post_remove';

/*
|--------------------------------------------------------------------------
| post like
|--------------------------------------------------------------------------
*/

/// __requires__
/// * [PostLikeTable.likedPostId] - fetch likes for provided post id
///
/// optional
/// * [PostLikeTable.id] - offset
///
/// __returns__
///
/// * [PostLikeModel]
/// * [UserModel]
///
/// additional returns
/// * [UserFollowModel] - whether returned [UserModel] is followed by session user
///
const REQ_TYPE_POST_LIKE_LOAD_LATEST = 'post_like_load_latest';

/// see [REQ_TYPE_POST_LIKE_LOAD_LATEST] for more information
const REQ_TYPE_POST_LIKE_LOAD_BOTTOM = 'post_like_load_bottom';

// actions

/// __requires__
/// * [PostLikeTable.likedPostId] - post id to like
///
/// __returns__
///
/// * [PostLikeModel]
///
const REQ_TYPE_POST_LIKE_ADD = 'post_like_add';

/// __requires__
/// * [PostLikeTable.likedPostId] - post id to unlike
///
/// __returns__
///
/// * [PostLikeModel]
///
const REQ_TYPE_POST_LIKE_REMOVE = 'post_like_remove';

/*
|--------------------------------------------------------------------------
| post comment
|--------------------------------------------------------------------------
*/

/// __requires__
/// * [PostCommentTable.parentPostId] - parent post id
///
/// optional
/// * [PostCommentTable.replyToPostCommentId] - if provided, will fetch replies on a post comment
/// * [PostCommentTable.id] - offset
///
/// __returns__
///
/// * [PostCommentModel]
/// * [UserModel]
///
const REQ_TYPE_POST_COMMENT_LOAD_LATEST = 'post_comment_load_latest';

/// see [REQ_TYPE_POST_COMMENT_LOAD_LATEST] for more information
const REQ_TYPE_POST_COMMENT_LOAD_BOTTOM = 'post_comment_load_bottom';

// actions

/// __requires__
/// * [PostCommentTable.parentPostId] - post id where comment is going to be added
/// * [PostCommentTable.displayText] - comment contents as String
///
/// optional
/// * [PostCommentTable.replyToPostCommentId] - if provided, will add comment as reply to the comment having provided id
///
/// __returns__
///
/// * [PostCommentModel]
/// * [UserModel] current user
///
const REQ_TYPE_POST_COMMENT_ADD = 'post_comment_add';

/// __requires__
/// * [PostCommentTable.id] - id of the comment to remove
///
/// __returns__
/// Success message if succeed
///
const REQ_TYPE_POST_COMMENT_REMOVE = 'post_comment_remove';

/*
|--------------------------------------------------------------------------
| post comment like
|--------------------------------------------------------------------------
*/

/// __requires__
/// * [PostCommentLikeTable.likedPostCommentId] - parent post comment id
///
/// optional
/// * [PostCommentLikeTable.id] - offset
///
/// __returns__
///
/// * [PostCommentLikeModel]
/// * [UserModel]
///
const REQ_TYPE_POST_COMMENT_LIKE_LOAD_LATEST = 'post_comment_like_load_latest';

/// see [REQ_TYPE_POST_COMMENT_LIKE_LOAD_LATEST] for more information
const REQ_TYPE_POST_COMMENT_LIKE_LOAD_BOTTOM = 'post_comment_like_load_bottom';

// actions

/// __requires__
/// * [PostCommentLikeTable.likedPostCommentId] - id of post comment to like
///
/// __returns__
///
/// * [PostCommentLikeModel]
/// * [UserModel]
///
const REQ_TYPE_POST_COMMENT_LIKE_ADD = 'post_comment_like_add';

/// __requires__
/// * [PostCommentLikeTable.likedPostCommentId] - id of post comment to unlike
///
/// __returns__
/// Success message if succeed
///
const REQ_TYPE_POST_COMMENT_LIKE_REMOVE = 'post_comment_like_remove';

/*
|--------------------------------------------------------------------------
| post user tag
|--------------------------------------------------------------------------
*/

/// __requires__
/// * [PostUserTagTable.taggedUserId] - fetch posts where user with the
/// provided id is tagged
///
/// optional
/// * [PostUserTagTable.id] - offset
///
/// __returns__
///
/// * [PostUserTagModel]
/// * [UserModel]
/// * [PostModel]
///
/// additional returns
/// * [PostLikeModel]
/// * [PostSaveModel]
///
const REQ_TYPE_POST_USER_TAG_LOAD_LATEST = 'post_user_tag_load_latest';

/// see [REQ_TYPE_POST_TAGGED_PROFILE_FEEDS_LOAD_LATEST] for more information
const REQ_TYPE_POST_USER_TAG_LOAD_BOTTOM = 'post_user_tag_load_bottom';

/*
|--------------------------------------------------------------------------
| hashtag
|--------------------------------------------------------------------------
*/

/// __requires__
///
/// Requires either one of these
/// * [HashtagTable.id] = id of hashtag to fetch
///
/// (or)
///
/// * [HashtagTable.displayText] = display literal value of hashtag
///
/// __returns__
///
/// * [HashtagModel]
///
/// additional returns
/// * [HashtagFollowModel]
///
const REQ_TYPE_HASHTAG_LOAD_SINGLE = 'hashtag_load_single';

/*
|--------------------------------------------------------------------------
| hashtag follow
|--------------------------------------------------------------------------
*/

// actions

/// __requires__
/// * [HashtagTable.id] = id of hashtag to fetch
///
/// __returns__
///
/// * [HashtagFollowTable]
///
const REQ_TYPE_HASHTAG_FOLLOW_ADD = 'hashtag_follow_add';

/// see [REQ_TYPE_HASHTAG_FOLLOW_ADD] for more information
const REQ_TYPE_HASHTAG_FOLLOW_REMOVE = 'hashtag_follow_remove';

/*
|--------------------------------------------------------------------------
| hashtag post
|--------------------------------------------------------------------------
*/

/// optional
/// * [HashtagPostTable.postId] - offset
///
/// __returns__
///
/// * [PostModel]
/// * [UserModel]
///
/// additional returns
/// * [UserFollowModel]
/// * [PostLikeModel]
/// * [PostSaveModel]
///
const REQ_TYPE_HASHTAG_POST_GLOBAL_FEED_LOAD_LATEST = 'hashtag_post_global_feed_load_latest';

/// see [REQ_TYPE_HASHTAG_POST_GLOBAL_FEED_LOAD_LATEST] for more information
const REQ_TYPE_HASHTAG_POST_GLOBAL_FEED_LOAD_BOTTOM = 'hashtag_post_global_feed_load_bottom';

/// __requires__
/// * [HashtagPostTable.hashtagId] - fetch posts which contains provided hashtag
///
/// optional
/// * [HashtagPostTable.postId] - offset
///
/// __returns__
///
/// * [UserModel]
/// * [PostModel]
///
/// additional returns
/// * [PostLikeModel]
/// * [PostSaveModel]
///
const REQ_TYPE_HASHTAG_POST_HASHTAG_FEED_LOAD_LATEST = 'hashtag_post_hashtag_feed_load_latest';

/// see [REQ_TYPE_HASHTAG_POST_HASHTAG_FEED_LOAD_LATEST] for more information
const REQ_TYPE_HASHTAG_POST_HASHTAG_FEED_LOAD_BOTTOM = 'hashtag_post_hashtag_feed_load_bottom';

/*
|--------------------------------------------------------------------------
| collection
|--------------------------------------------------------------------------
*/

/// optional
/// * [CollectionTable.id] - offset
///
/// __returns__
///
/// * [CollectionModel]
///
const REQ_TYPE_COLLECTION_LOAD_LATEST = 'collection_load_latest';

/// see [REQ_TYPE_COLLECTION_LOAD_LATEST] for more information
const REQ_TYPE_COLLECTION_LOAD_BOTTOM = 'collection_load_bottom';

// actions

const REQ_TYPE_COLLECTION_ADD = 'collection_add';

const REQ_TYPE_COLLECTION_REMOVE = 'collection_remove';

const REQ_TYPE_COLLECTION_UPDATE = 'collection_update';

/*
|--------------------------------------------------------------------------
| post save
|--------------------------------------------------------------------------
*/

/// optional
/// * [PostSaveTable.savedToCollectionId] - fetch posts for single collection having the provided
/// collection id.
/// if not provided, posts from all collections will be returned anad might contain duplicates
/// therefore client has to handle duplicates on their own.
///
/// * [PostSaveTable.id] - offset
///
/// __returns__
///
/// * [PostSaveModel]
/// * [PostModel]
/// * [UserModel]
///
/// additional returns
/// * [PostLikeModel]
/// * [PostSaveModel]
///
const REQ_TYPE_POST_SAVE_LOAD_LATEST = 'post_save_load_latest';

/// see [REQ_TYPE_POST_SAVE_LOAD_LATEST] for more information
const REQ_TYPE_POST_SAVE_LOAD_BOTTOM = 'post_save_load_bottom';

// actions

const REQ_TYPE_POST_SAVE_ADD = 'post_save_add';

const REQ_TYPE_POST_SAVE_REMOVE = 'post_save_remove';

/*
|--------------------------------------------------------------------------
| notification
|--------------------------------------------------------------------------
*/

/// returns unread notification count
/// __returns__
///
/// * [NotificationsCountDTO]
/// it only returns count, not content
///
const REQ_TYPE_NOTIFICATION_COUNT = 'notification_count';

/// optional
/// * [NotificationTable.id] - offset
///
/// __returns__
///
/// * [NotificationModel]
///
/// * [UserModel] [maybe] linked users
/// * [PostModel] [maybe] linked posts
///
/// additional returns
/// * [UserFollowModel]
/// * [PostLikeModel]
/// * [PostSaveModel]
///
const REQ_TYPE_NOTIFICATION_LOAD_LATEST = 'notification_load_latest';

/// see [REQ_TYPE_NOTIFICATION_LOAD_LATEST] for more information
const REQ_TYPE_NOTIFICATION_LOAD_BOTTOM = 'notification_load_bottom';

/*
|--------------------------------------------------------------------------
| other requests
|--------------------------------------------------------------------------
*/

/*
|--------------------------------------------------------------------------
| misc
|--------------------------------------------------------------------------
*/

/// For getting upto-date client-only settings from server
/// settings that aren't relevant for client are not included
/// in the response
const REQ_TYPE_MISC_SETTINGS = 'misc_settings';

/// __returns__
///
/// * [ApiCompatiblityDTO]
///
const REQ_TYPE_MISC_COMPATIBILITY = 'misc_compatibility';

/*
|--------------------------------------------------------------------------
| admin
|--------------------------------------------------------------------------
*/

// session

const REQ_TYPE_ADMIN_SESSION = 'admin_session';

const REQ_TYPE_ADMIN_LOGIN = 'admin_login';

const REQ_TYPE_ADMIN_LOGOUT = 'admin_logout';
