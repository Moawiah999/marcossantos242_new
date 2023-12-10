class PostCommentTable {
  static const tableName = 'postcomment';

  // primary key

  static const id = 'id';

  // ids

  static const ownerUserId = 'owner_user_id';
  static const parentPostId = 'parent_post_id';
  static const replyToPostCommentId = 'reply_to_postcomment_id';

  // display

  static const displayText = 'display_text';

  // cache

  static const cacheLikesCount = 'cache_likes_count';
  static const cacheCommentsCount = 'cache_comments_count';

  // stamp

  static const stampRegistration = 'stamp_registration';
  static const stampLastUpdate = 'stamp_last_update';
}
