class UserFollowTable {
  static const tableName = 'userfollow';

  // primary key

  static const id = 'id';

  // ids

  static const followedUserId = 'followed_user_id';

  static const followedByUserId = 'followed_by_user_id';

  static const metaIsPending = 'meta_is_pending';

  // stamps

  static const stampRegistration = 'stamp_registration';

  static const stampLastUpdate = 'stamp_last_update';
}
