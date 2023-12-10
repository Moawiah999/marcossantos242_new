import 'package:photogram/import/core.dart';

class PostMetaHashtagsDTO {
  var _isDTO = false;

  /*
  |--------------------------------------------------------------------------
  | data
  |--------------------------------------------------------------------------
  */

  late final Map<String, String> _entries;

  /*
  |--------------------------------------------------------------------------
  | getters
  |--------------------------------------------------------------------------
  */

  bool get isDTO => _isDTO;
  bool get isNotDTO => !_isDTO;

  /// hashtag literal value to its id map
  ///
  /// e.g lets say a post content contains #somehashtag, #anotherhashtag
  /// then entries will be:
  ///
  /// {
  ///
  ///     "somehashtag": 123 // 123 is id of hashtag,
  ///
  ///     "anotherhashtag": 321
  ///
  /// }
  ///
  Map<String, String> get entries => _entries;

  /*
  |--------------------------------------------------------------------------
  | from json
  |--------------------------------------------------------------------------
  */

  PostMetaHashtagsDTO.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      _entries = Map<String, String>.from(jsonMap);

      _isDTO = true;
    } catch (e) {
      AppLogger.info(e, logType: AppLogType.parser);
    }
  }
}
