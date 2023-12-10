import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class PostCommentModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _ownerUserId;
  late String _parentPostId;
  late String _replyToPostCommentId;

  // display

  late String _displayText;

  // cache

  late int _cacheLikesCount;
  late int _cacheCommentsCount;

  // stamps

  late String _stampRegistration;
  late String _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // ids

  String get ownerUserId => _ownerUserId;
  String get parentPostId => _parentPostId;
  String get replyToPostCommentId => _replyToPostCommentId;

  // display

  String get displayText => _displayText;

  // cache

  int get cacheLikesCount => _cacheLikesCount;
  int get cacheCommentsCount => _cacheCommentsCount;

  // stamps

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  PostCommentModel();

  factory PostCommentModel.none() => PostCommentModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  PostCommentModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary

      _intId = AppUtils.intVal(jsonMap[PostCommentTable.id]);
      _stringId = jsonMap[PostCommentTable.id];

      // ids

      _replyToPostCommentId = jsonMap[PostCommentTable.replyToPostCommentId];

      _parentPostId = jsonMap[PostCommentTable.parentPostId];

      _ownerUserId = jsonMap[PostCommentTable.ownerUserId];

      // display

      _displayText = jsonMap[PostCommentTable.displayText];

      // cache

      _cacheLikesCount = AppUtils.intVal(jsonMap[PostCommentTable.cacheLikesCount]);
      _cacheCommentsCount = AppUtils.intVal(jsonMap[PostCommentTable.cacheCommentsCount]);

      // stamps

      _stampRegistration = jsonMap[PostCommentTable.stampRegistration];
      _stampLastUpdate = jsonMap[PostCommentTable.stampLastUpdate];

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
        // primary key

        PostCommentTable.id: id,

        // ids

        PostCommentTable.replyToPostCommentId: replyToPostCommentId,

        PostCommentTable.parentPostId: parentPostId,
        PostCommentTable.ownerUserId: ownerUserId,

        // display

        PostCommentTable.displayText: displayText,

        // cache

        PostCommentTable.cacheLikesCount: cacheLikesCount,
        PostCommentTable.cacheCommentsCount: cacheCommentsCount,

        // stamp

        PostCommentTable.stampRegistration: stampRegistration,
        PostCommentTable.stampLastUpdate: stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as PostCommentModel;

    // ids

    _replyToPostCommentId = receivedModel.replyToPostCommentId;

    _parentPostId = receivedModel.parentPostId;

    _ownerUserId = receivedModel.ownerUserId;

    // display

    _displayText = receivedModel.displayText;

    // cache

    _cacheLikesCount = receivedModel.cacheLikesCount;
    _cacheCommentsCount = receivedModel.cacheCommentsCount;

    // stamps

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;

    // gracefully handle model state updates

    if (!_liked && receivedModel.isLiked) {
      _liked = true;
    }
  }

  /*
  |--------------------------------------------------------------------------
  | client specific implementations
  |--------------------------------------------------------------------------
  */

  var _liked = false;

  bool get isLiked => _liked;
  bool get isNotLiked => !_liked;

  bool setLiked(bool setTo, {bool keepCache = false}) {
    if (keepCache) {
      _liked = setTo;
      return setTo;
    }

    // unlike
    if (!setTo && isLiked) {
      var totalLikes = cacheLikesCount - 1;

      if (totalLikes > -1) {
        _cacheLikesCount = totalLikes;
      }
    }

    // like
    if (setTo && isNotLiked) {
      var totalLikes = cacheLikesCount + 1;

      if (totalLikes > -1) {
        _cacheLikesCount = totalLikes;
      }
    }

    _liked = setTo;

    return setTo;
  }
}
