import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class PostDisplayUserTagsOnItemDTO {
  var _isDTO = false;

  /*
  |--------------------------------------------------------------------------
  | data
  |--------------------------------------------------------------------------
  */

  late final List<PostDisplayUserTagDTO> _tags;

  /*
  |--------------------------------------------------------------------------
  | getters
  |--------------------------------------------------------------------------
  */

  bool get isDTO => _isDTO;
  bool get isNotDTO => !_isDTO;

  int get length => _tags.length;
  bool get isEmpty => _tags.isEmpty;
  bool get isNotEmpty => _tags.isNotEmpty;

  List<PostDisplayUserTagDTO> get tags => _tags;

  /*
  |--------------------------------------------------------------------------
  | constructor
  |--------------------------------------------------------------------------
  */

  PostDisplayUserTagsOnItemDTO({
    required List<PostDisplayUserTagDTO> tags,
  }) {
    _tags = tags;

    _isDTO = true;
  }

  /*
  |--------------------------------------------------------------------------
  | from json
  |--------------------------------------------------------------------------
  */

  PostDisplayUserTagsOnItemDTO.fromJson(List jsonList) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      _tags = <PostDisplayUserTagDTO>[];

      for (var userTagData in jsonList) {
        var userTagDTO = PostDisplayUserTagDTO.fromJson(userTagData);

        if (userTagDTO.isNotDTO) {
          throw Exception();
        }

        _tags.add(userTagDTO);
      }

      _isDTO = true;
    } catch (e) {
      AppLogger.info(e, logType: AppLogType.parser);
    }
  }
}
