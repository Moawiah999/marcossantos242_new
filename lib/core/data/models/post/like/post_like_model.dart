import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class PostLikeModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _likedPostId;
  late String _likedByUserId;

  // stamps

  late String _stampRegistration;
  late String _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // ids

  String get likedPostId => _likedPostId;
  String get likedByUserId => _likedByUserId;

  // stamps

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  PostLikeModel();

  factory PostLikeModel.none() => PostLikeModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  PostLikeModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary key

      _intId = AppUtils.intVal(jsonMap[PostLikeTable.id]);
      _stringId = jsonMap[PostLikeTable.id];

      // ids

      _likedPostId = jsonMap[PostLikeTable.likedPostId];
      _likedByUserId = jsonMap[PostLikeTable.likedByUserId];

      // stamps

      _stampRegistration = jsonMap[PostLikeTable.stampRegistration];
      _stampLastUpdate = jsonMap[PostLikeTable.stampLastUpdate];

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
        // ids
        PostLikeTable.id: id,

        PostLikeTable.likedPostId: likedPostId,
        PostLikeTable.likedByUserId: likedByUserId,

        // stamp
        PostLikeTable.stampRegistration: stampRegistration,
        PostLikeTable.stampLastUpdate: stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as PostLikeModel;

    // ids

    _likedPostId = receivedModel.likedPostId;
    _likedByUserId = receivedModel.likedByUserId;

    // stamps

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;
  }
}
