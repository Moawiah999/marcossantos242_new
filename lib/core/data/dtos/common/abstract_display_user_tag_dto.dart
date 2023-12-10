import 'package:photogram/import/core.dart';

abstract class AbstractDisplayUserTagDTO {
  var _isDTO = false;

  /*
  |--------------------------------------------------------------------------
  | data
  |--------------------------------------------------------------------------
  */

  late final int _userId;
  late final String _username;
  late final int _offsetTop;
  late final int _offsetLeft;

  /*
  |--------------------------------------------------------------------------
  | getters
  |--------------------------------------------------------------------------
  */

  bool get isDTO => _isDTO;
  bool get isNotDTO => !_isDTO;

  int get userId => _userId;
  String get username => _username;
  int get offsetTop => _offsetTop;
  int get offsetLeft => _offsetLeft;

  /*
  |--------------------------------------------------------------------------
  | constructors
  |--------------------------------------------------------------------------
  */

  AbstractDisplayUserTagDTO({
    required int userId,
    required String username,
    required int offsetTop,
    required int offsetLeft,
  }) {
    _userId = userId;
    _username = username;
    _offsetTop = offsetTop;
    _offsetLeft = offsetLeft;

    _isDTO = true;
  }

  /*
  |--------------------------------------------------------------------------
  | from json
  |--------------------------------------------------------------------------
  */

  AbstractDisplayUserTagDTO.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      _userId = AppUtils.intVal(jsonMap[keyUserId]);
      _username = jsonMap[keyUsername];
      _offsetTop = AppUtils.intVal(jsonMap[keyOffsetTop]);
      _offsetLeft = AppUtils.intVal(jsonMap[keyOffsetLeft]);

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

  Map<String, dynamic> toJson() {
    return {
      keyUserId: _userId,
      keyUsername: _username,
      keyOffsetTop: _offsetTop,
      keyOffsetLeft: _offsetLeft,
    };
  }

  /*
  |--------------------------------------------------------------------------
  | key maps, warning! must not change
  |--------------------------------------------------------------------------
  */

  static const keyUserId = 'user_id';

  static const keyUsername = 'username';

  static const keyOffsetTop = 'offset_top';

  static const keyOffsetLeft = 'offset_left';
}
