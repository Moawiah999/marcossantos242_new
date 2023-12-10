class PostCommentLikeTable {
  static const tableName = 'postcommentlike';

  // primary key

  static const id = 'id';

  // ids

  static const likedByUserId = 'liked_by_user_id';

  static const likedPostCommentId = 'liked_postcomment_id';

  static const parentPostId = 'parent_post_id';

  // stamps

  static const stampRegistration = 'stamp_registration';

  static const stampLastUpdate = 'stamp_last_update';
}
