class NotifcationTable {
  static const tableName = 'notification';

  // primary key

  static const id = 'id';

  static const toUserId = 'to_user_id';

  // linked

  static const linkedContent = 'linked_content';

  // meta

  static const metaType = 'meta_type';
  static const metaIsRead = 'meta_is_read';

  // stamp

  static const stampRegistration = 'stamp_registration';
  static const stampLastUpdate = 'stamp_last_update';
}
