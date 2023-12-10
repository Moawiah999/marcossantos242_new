import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class HashtagPostModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _hashtagId;
  late String _postId;
  late String _postOwnerUserId;

  // stamps

  late String _stampRegistration;
  late String _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // ids

  String get hashtagId => _hashtagId;
  String get postId => _postId;
  String get postOwnerUserId => _postOwnerUserId;

  // stamps

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  HashtagPostModel();

  factory HashtagPostModel.none() => HashtagPostModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  HashtagPostModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary key

      _intId = AppUtils.intVal(jsonMap[HashtagPostTable.id]);
      _stringId = jsonMap[HashtagPostTable.id];

      // ids

      _hashtagId = jsonMap[HashtagPostTable.hashtagId];
      _postId = jsonMap[HashtagPostTable.postId];
      _postOwnerUserId = jsonMap[HashtagPostTable.postOwnerUserId];

      // stamps

      _stampRegistration = jsonMap[HashtagPostTable.stampRegistration];
      _stampLastUpdate = jsonMap[HashtagPostTable.stampLastUpdate];

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

  Map<String, dynamic> toJson() => <String, dynamic>{
        HashtagPostTable.id: id,

        // ids

        HashtagPostTable.hashtagId: hashtagId,
        HashtagPostTable.postId: postId,
        HashtagPostTable.postOwnerUserId: postOwnerUserId,

        // stamp

        HashtagPostTable.stampRegistration: stampRegistration,
        HashtagPostTable.stampLastUpdate: stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as HashtagPostModel;

    // ids

    _hashtagId = receivedModel.hashtagId;
    _postId = receivedModel.postId;
    _postOwnerUserId = receivedModel.postOwnerUserId;

    // stamps

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;
  }
}
