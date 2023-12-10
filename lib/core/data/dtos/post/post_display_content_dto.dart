import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class PostDisplayContentDTO {
  var _isDTO = false;

  /*
  |--------------------------------------------------------------------------
  | data
  |--------------------------------------------------------------------------
  */

  late final List<PostDisplayContentItemDTO> _items;

  /*
  |--------------------------------------------------------------------------
  | getters
  |--------------------------------------------------------------------------
  */

  bool get isDTO => _isDTO;
  bool get isNotDTO => !_isDTO;

  String get firstImageUrl => _items.first.displayItemDTO.urlCompressed;

  int get length => _items.length;

  List<PostDisplayContentItemDTO> get items => _items;

  /*
  |--------------------------------------------------------------------------
  | constructor
  |--------------------------------------------------------------------------
  */

  PostDisplayContentDTO({
    required List<PostDisplayContentItemDTO> items,
  }) {
    _items = items;

    _isDTO = true;
  }

  /*
  |--------------------------------------------------------------------------
  | from json
  |--------------------------------------------------------------------------
  */

  PostDisplayContentDTO.fromJsonList(List jsonList) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      _items = <PostDisplayContentItemDTO>[];

      for (var itemData in jsonList) {
        var displayContentItemDTO = PostDisplayContentItemDTO.fromJson(itemData);

        if (displayContentItemDTO.isNotDTO) {
          throw Exception();
        }

        _items.add(displayContentItemDTO);
      }

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

  List toJson() => _items;
}
