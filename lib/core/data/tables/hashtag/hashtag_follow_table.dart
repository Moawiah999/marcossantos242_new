class HashtagFollowTable {
  /*
  |--------------------------------------------------------------------------
  | class meta data
  |--------------------------------------------------------------------------
  */

  static const tableName = 'hashtagfollow';

  /*
  |--------------------------------------------------------------------------
  | fields/attributes
  |--------------------------------------------------------------------------
  */

  static const id = 'id';

  static const followedHashtagId = 'followed_hashtag_id';

  static const followedByUserId = 'followed_by_user_id';

  static const stampRegistration = 'stamp_registration';

  static const stampLastUpdate = 'stamp_last_update';
}
