import 'package:photogram/import/core.dart';

class NotificationsCountDTO {
  var _isDTO = false;

  static const dtoName = 'notifications_count_dto';

  /*
  |--------------------------------------------------------------------------
  | data
  |--------------------------------------------------------------------------
  */

  late final String _likeCount;
  late final String _commentCount;
  late final String _followCount;
  late final String _otherCount;

  /*
  |--------------------------------------------------------------------------
  | getters
  |--------------------------------------------------------------------------
  */

  bool get isDTO => _isDTO;
  bool get isNotDTO => !_isDTO;

  String get likeCount => _likeCount;
  String get commentCount => _commentCount;
  String get followCount => _followCount;
  String get otherCount => _otherCount;

  /*
  |--------------------------------------------------------------------------
  | from data
  |--------------------------------------------------------------------------
  */

  NotificationsCountDTO({
    required String likeCount,
    required String commentCount,
    required String followCount,
    required String otherCount,
  }) {
    _likeCount = likeCount;
    _commentCount = commentCount;
    _followCount = followCount;
    _otherCount = otherCount;
  }

  /*
  |--------------------------------------------------------------------------
  | from json
  |--------------------------------------------------------------------------
  */

  NotificationsCountDTO.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      _likeCount = jsonMap[keyLikeCount];
      _commentCount = jsonMap[keyCommentCount];
      _followCount = jsonMap[keyFollowCount];
      _otherCount = jsonMap[keyOtherCount];

      _isDTO = true;
    } catch (e) {
      AppLogger.info(e, logType: AppLogType.parser);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | to json
  |--------------------------------------------------------------------------
  */

  Map<String, dynamic> toJson() => {
        keyLikeCount: _likeCount,
        keyCommentCount: _commentCount,
        keyFollowCount: _followCount,
        keyOtherCount: _otherCount,
      };

  /*
  |--------------------------------------------------------------------------
  | key maps, warning! must not change
  |--------------------------------------------------------------------------
  */

  static const keyLikeCount = 'like_count';

  static const keyCommentCount = 'comment_count';

  static const keyFollowCount = 'follow_count';

  static const keyOtherCount = 'other_count';
}
