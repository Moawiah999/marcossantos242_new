class CollectionTable {
  static const tableName = 'collection';

  // primary key

  static const id = 'id';

  // ids

  static const ownerUserId = 'owner_user_id';

  // display

  static const displayTitle = 'display_title';

  static const displayImage = 'display_image';

  // stamp

  static const stampRegistration = 'stamp_registration';

  static const stampLastUpdate = 'stamp_last_update';

  // extra fields(used only to pass some data over REST, not stored in database)

  static const extraCoverPostId = 'extra_cover_post_id';

  static const extraCoverPostSaveId = 'extra_cover_postsave_id';
}
