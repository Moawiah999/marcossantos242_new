class PostTable {
  static const tableName = 'post';

  // primary key

  static const id = 'id';

  // ids

  static const ownerUserId = 'owner_user_id';

  // display

  static const displayCaption = 'display_caption';
  static const displayLocation = 'display_location';
  static const displayContent = 'display_content';

  // meta

  static const metaHashtags = 'meta_hashtags';

  // cache

  static const cacheLikesCount = 'cache_likes_count';
  static const cacheCommentsCount = 'cache_comments_count';

  // stamp

  static const stampRegistration = 'stamp_registration';
  static const stampLastUpdate = 'stamp_last_update';
}
