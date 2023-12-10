class UserTable {
  static const tableName = 'user';

  // primary key

  static const id = 'id';

  // creds

  static const email = 'email';
  static const username = 'username';
  static const password = 'password';

  // display

  static const displayName = 'display_name';
  static const displayBio = 'display_bio';
  static const displayImage = 'display_image';
  static const displayWeb = 'display_web';

  // meta

  static const metaAccess = 'meta_access';
  static const metaIsPrivate = 'meta_is_private';
  static const metaLastActive = 'meta_last_active';
  static const metaPushSettings = 'meta_push_settings';

  // cache

  static const cachePostsCount = 'cache_posts_count';
  static const cacheFollowersCount = 'cache_followers_count';
  static const cacheFollowingsCount = 'cache_followings_count';

  // stamp

  static const stampRegistration = 'stamp_registration';
  static const stampLastUpdate = 'stamp_last_update';

  // extra fields(used only to pass some data over REST, not stored in database)

  static const extraNewPassword = 'extra_new_password';
  static const extraRetypeNewPassword = 'extra_retype_new_password';
}
