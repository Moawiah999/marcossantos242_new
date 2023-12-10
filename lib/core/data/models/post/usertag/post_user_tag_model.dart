import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class PostUserTagModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _taggedUserId;
  late String _taggedInPostId;
  late String _postOwnerUserId;

  // stamp

  late String _stampRegistration;
  late String _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | getters
  |--------------------------------------------------------------------------
  */

  // ids

  String get taggedUserId => _taggedUserId;
  String get taggedInPostId => _taggedInPostId;
  String get postOwnerUserId => _postOwnerUserId;

  // stamp

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  PostUserTagModel();

  factory PostUserTagModel.none() => PostUserTagModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  PostUserTagModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary key as int
      _intId = AppUtils.intVal(jsonMap[PostUserTagTable.id]);

      _stringId = jsonMap[PostUserTagTable.id];

      // ids

      _taggedUserId = jsonMap[PostUserTagTable.taggedUserId];
      _taggedInPostId = jsonMap[PostUserTagTable.taggedInPostId];
      _postOwnerUserId = jsonMap[PostUserTagTable.postOwnerUserId];

      // stamps

      _stampRegistration = jsonMap[PostUserTagTable.stampRegistration];
      _stampLastUpdate = jsonMap[PostUserTagTable.stampLastUpdate];

      isModel = true;

      /*
      |--------------------------------------------------------------------------
      | failed
      |--------------------------------------------------------------------------
      */
    } catch (e) {
      AppLogger.info(e, logType: AppLogType.parser);
    }
  }

  Map<String, String> toJson() => <String, String>{
        // primary key
        PostUserTagTable.id: id,

        // ids

        PostUserTagTable.taggedUserId: taggedUserId,
        PostUserTagTable.taggedInPostId: taggedInPostId,
        PostUserTagTable.postOwnerUserId: postOwnerUserId,

        // stamp

        PostUserTagTable.stampRegistration: stampRegistration,
        PostUserTagTable.stampLastUpdate: stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as PostUserTagModel;

    // ids

    _taggedUserId = receivedModel.taggedUserId;
    _taggedInPostId = receivedModel.taggedInPostId;
    _postOwnerUserId = receivedModel.postOwnerUserId;

    // stamps

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;
  }
}
