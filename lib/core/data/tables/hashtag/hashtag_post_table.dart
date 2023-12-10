class HashtagPostTable {
  static const tableName = 'hashtagpost';

  /*
  |--------------------------------------------------------------------------
  | fields/attributes
  |--------------------------------------------------------------------------
  */

  // primary key

  static const id = 'id';

  // ids

  static const hashtagId = 'hashtag_id';

  static const postId = 'post_id';

  static const postOwnerUserId = 'post_owner_user_id';

  // stamp

  static const stampRegistration = 'stamp_registration';

  static const stampLastUpdate = 'stamp_last_update';
}
