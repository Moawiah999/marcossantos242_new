import 'package:photogram/import/core.dart';

abstract class StringCollectionMapDTO {
  var _isDTO = false;

  /*
  |--------------------------------------------------------------------------
  | data
  |--------------------------------------------------------------------------
  */

  late final _collections = <String, List<String>>{};

  /*
  |--------------------------------------------------------------------------
  | getters
  |--------------------------------------------------------------------------
  */

  bool get isDTO => _isDTO;
  bool get isNotDTO => !_isDTO;

  int get length => _collections.length;

  Map<String, List<String>> get collections => _collections;

  /*
  |--------------------------------------------------------------------------
  | constructor
  |--------------------------------------------------------------------------
  */

  StringCollectionMapDTO({
    required Map<String, List<String>> collections,
  }) {
    collections.addAll(collections);

    _isDTO = true;
  }

  /*
  |--------------------------------------------------------------------------
  | from json
  |--------------------------------------------------------------------------
  */

  StringCollectionMapDTO.fromJson(Map<String, dynamic> jsonMap) {
    try {
      var items = Map<String, List>.from(jsonMap);

      // we've to downcast list string mannually
      items.forEach((key, value) {
        _collections.addAll({key: List<String>.from(value)});
      });

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

  Map<String, dynamic> toJson() => _collections;
}
