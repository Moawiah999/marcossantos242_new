import 'package:photogram/import/core.dart';

class ApiCompatibilityDTO {
  var _isDTO = false;

  static const dtoName = 'api_compatibility_dto';

  /*
  |--------------------------------------------------------------------------
  | data
  |--------------------------------------------------------------------------
  */

  late final String _status;
  late final String _message;
  late final String _iosUpdateUrl;
  late final String _androidUpdateUrl;

  /*
  |--------------------------------------------------------------------------
  | getters
  |--------------------------------------------------------------------------
  */

  bool get isDTO => _isDTO;
  bool get isNotDTO => !_isDTO;

  String get status => _status;
  String get message => _message;
  String get iosUpdateUrl => _iosUpdateUrl;
  String get androidUpdateUrl => _androidUpdateUrl;

  /*
  |--------------------------------------------------------------------------
  | from json
  |--------------------------------------------------------------------------
  */

  ApiCompatibilityDTO.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      _status = jsonMap[keyStatus];
      _message = jsonMap[keyMessage];
      _iosUpdateUrl = jsonMap[keyIosUpdateUrl];
      _androidUpdateUrl = jsonMap[keyAndroidUpdateUrl];

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
        keyStatus: _status,
        keyMessage: _message,
        keyIosUpdateUrl: _iosUpdateUrl,
        keyAndroidUpdateUrl: _androidUpdateUrl,
      };

  /*
  |--------------------------------------------------------------------------
  | key maps, warning! must not change
  |--------------------------------------------------------------------------
  */

  static const keyStatus = 'status';

  static const keyMessage = 'message';

  static const keyIosUpdateUrl = 'ios_update_url';

  static const keyAndroidUpdateUrl = 'android_update_url';

  /*
  |--------------------------------------------------------------------------
  | status values
  |--------------------------------------------------------------------------
  */

  static const statusSupported = 'supported';

  static const statusRequiresUpdate = 'requires_update';
}
