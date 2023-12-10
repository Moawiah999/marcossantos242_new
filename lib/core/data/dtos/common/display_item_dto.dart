import 'package:photogram/import/core.dart';

class DisplayItemDTO {
  var _isDTO = false;

  /*
  |--------------------------------------------------------------------------
  | data
  |--------------------------------------------------------------------------
  */

  late final String _host;
  late final String _type;
  late final String _filespace;
  late final String _identifier;

  late final String _urlOriginal;
  late final String _urlCompressed;

  /*
  |--------------------------------------------------------------------------
  | getters
  |--------------------------------------------------------------------------
  */

  bool get isDTO => _isDTO;
  bool get isNotDTO => !_isDTO;

  bool get isImage => _type == typeImage;
  bool get isVideo => _type == typeVideo;

  String get host => _host;
  String get type => _type;
  String get filespace => _filespace;
  String get identifier => _identifier;

  String get urlOriginal => _urlOriginal;
  String get urlCompressed => _urlCompressed;

  /*
  |--------------------------------------------------------------------------
  | from json
  |--------------------------------------------------------------------------
  */

  DisplayItemDTO.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      _type = jsonMap[keyType];
      _host = jsonMap[keyHost];
      _filespace = jsonMap[keyFilespace];
      _identifier = jsonMap[keyIdentifier];

      _urlOriginal = jsonMap[keyUrlOriginal];
      _urlCompressed = jsonMap[keyUrlCompressed];

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
        keyType: _type,
        keyHost: _host,
        keyFilespace: _filespace,
        keyIdentifier: _identifier,
        keyUrlOriginal: _urlOriginal,
        keyUrlCompressed: _urlCompressed,
      };

  /*
  |--------------------------------------------------------------------------
  | key maps, warning! must not change
  |--------------------------------------------------------------------------
  */

  static const keyHost = 'host';

  static const keyType = 'type';

  static const keyFilespace = 'filespace';

  static const keyIdentifier = 'identifier';

  static const keyUrlOriginal = 'url_original';

  static const keyUrlCompressed = 'url_compressed';

  /*
  |--------------------------------------------------------------------------
  | available types
  |--------------------------------------------------------------------------
  */

  static const typeImage = 'image';

  static const typeVideo = 'video';

  /*
  |--------------------------------------------------------------------------
  | available namespaces
  |--------------------------------------------------------------------------
  */

  static const filespaceUser = 'user';

  static const filespacePost = 'post';

  static const filespaceCollection = 'collection';

  static const filespacePlaceholder = 'placeholder';
}
