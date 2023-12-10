import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class PostCommentLikeModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _likedByUserId;
  late String _likedPostCommentId;
  late String _parentPostId;

  // stamps

  late String _stampRegistration;
  late String _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // ids

  String get likedByUserId => _likedByUserId;
  String get likedPostCommentId => _likedPostCommentId;
  String get parentPostId => _parentPostId;

  // stamps

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  PostCommentLikeModel();

  factory PostCommentLikeModel.none() => PostCommentLikeModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  PostCommentLikeModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary key

      _intId = AppUtils.intVal(jsonMap[PostCommentLikeTable.id]);
      _stringId = jsonMap[PostCommentLikeTable.id];

      // ids

      _parentPostId = jsonMap[PostCommentLikeTable.parentPostId];
      _likedByUserId = jsonMap[PostCommentLikeTable.likedByUserId];
      _likedPostCommentId = jsonMap[PostCommentLikeTable.likedPostCommentId];

      // stamps

      _stampRegistration = jsonMap[PostCommentLikeTable.stampRegistration];
      _stampLastUpdate = jsonMap[PostCommentLikeTable.stampLastUpdate];

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

        PostCommentLikeTable.id: id,

        // ids

        PostCommentLikeTable.parentPostId: parentPostId,
        PostCommentLikeTable.likedByUserId: likedByUserId,
        PostCommentLikeTable.likedPostCommentId: likedPostCommentId,

        // stamp

        PostCommentLikeTable.stampRegistration: stampRegistration,
        PostCommentLikeTable.stampLastUpdate: stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as PostCommentLikeModel;

    // ids

    _parentPostId = receivedModel.parentPostId;
    _likedByUserId = receivedModel.likedByUserId;
    _likedPostCommentId = receivedModel.likedPostCommentId;

    // stamps

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;
  }
}
