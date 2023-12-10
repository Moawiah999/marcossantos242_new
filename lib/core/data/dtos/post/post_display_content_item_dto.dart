import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class PostDisplayContentItemDTO {
  var _isDTO = false;

  /*
  |--------------------------------------------------------------------------
  | data
  |--------------------------------------------------------------------------
  */

  late final PostDisplayItemDTO _displayItemDTO;
  late final PostDisplayUserTagsOnItemDTO _displayUserTagsOnItemDTO;

  /*
  |--------------------------------------------------------------------------
  | getters
  |--------------------------------------------------------------------------
  */

  bool get isDTO => _isDTO;
  bool get isNotDTO => !_isDTO;

  PostDisplayItemDTO get displayItemDTO => _displayItemDTO;
  PostDisplayUserTagsOnItemDTO get displayUserTagsOnItemDTO => _displayUserTagsOnItemDTO;

  /*
  |--------------------------------------------------------------------------
  | constructor
  |--------------------------------------------------------------------------
  */

  PostDisplayContentItemDTO({
    required PostDisplayItemDTO displayItemDTO,
    required PostDisplayUserTagsOnItemDTO displayUserTagsOnItemDTO,
  }) {
    _displayItemDTO = displayItemDTO;
    _displayUserTagsOnItemDTO = displayUserTagsOnItemDTO;

    _isDTO = true;
  }

  /*
  |--------------------------------------------------------------------------
  | from json
  |--------------------------------------------------------------------------
  */

  PostDisplayContentItemDTO.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      _displayItemDTO = PostDisplayItemDTO.fromJson(jsonMap[keyDisplayItem]);

      _displayUserTagsOnItemDTO = PostDisplayUserTagsOnItemDTO.fromJson(jsonMap[keyDisplayUserTags]);

      if (_displayItemDTO.isNotDTO || _displayUserTagsOnItemDTO.isNotDTO) {
        throw Exception();
      }

      _isDTO = true;
    } catch (e) {
      AppLogger.info(e, logType: AppLogType.parser);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | key map, warning! must not change
  |--------------------------------------------------------------------------
  */

  static const keyDisplayItem = 'display_item';

  static const keyDisplayUserTags = 'user_tags';
}
