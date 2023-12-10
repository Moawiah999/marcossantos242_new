import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class AppSettings {
  static late final ApiRepository apiRepository;
  static var _isReady = false;

  /*
  |--------------------------------------------------------------------------
  | default settings
  |--------------------------------------------------------------------------
  */

  static final _default = {
    /*
    |--------------------------------------------------------------------------
    | user
    |--------------------------------------------------------------------------
    */

    SETTING_MAX_LEN_USER_USERNAME: '50',
    SETTING_MIN_LEN_USER_USERNAME: '6',
    SETTING_MAX_LEN_USER_EMAIL: '250',
    SETTING_MIN_LEN_USER_EMAIL: '6',
    SETTING_MAX_LEN_USER_PASSWORD: '100',
    SETTING_MIN_LEN_USER_PASSWORD: '6',
    SETTING_MAX_LEN_USER_DISPLAY_NAME: '100',
    SETTING_MIN_LEN_USER_DISPLAY_NAME: '0',
    SETTING_MAX_LEN_USER_DISPLAY_BIO: '100',
    SETTING_MIN_LEN_USER_DISPLAY_BIO: '0',
    SETTING_MAX_LEN_USER_DISPLAY_WEB: '100',
    SETTING_MIN_LEN_USER_DISPLAY_WEB: '0',
    SETTING_MAX_USER_DISPLAY_IMAGE_FILE_SIZE: '10',
    SETTING_SUPPORTED_USER_DISPLAY_IMAGE_FILE_FORMAT: 'png, jpg, jpeg, webp, bmp',

    /*
    |--------------------------------------------------------------------------
    | post
    |--------------------------------------------------------------------------
    */

    SETTING_MAX_LEN_POST_DISPLAY_CAPTION: '3000',
    SETTING_MIN_LEN_POST_DISPLAY_CAPTION: '0',
    SETTING_MAX_LEN_POST_DISPLAY_LOCATION: '100',
    SETTING_MIN_LEN_POST_DISPLAY_LOCATION: '0',
    SETTING_MAX_POST_DISPLAY_CONTENT_ITEM: '12',
    SETTING_MIN_POST_DISPLAY_CONTENT_ITEM: '1',
    SETTING_MAX_POST_HASHTAG: '8',
    SETTING_MIN_POST_HASHTAG: '0',
    SETTING_MAX_LEN_POST_HASHTAG: '35',
    SETTING_MIN_LEN_POST_HASHTAG: '3',
    SETTING_MAX_POST_USER_TAG_PER_ITEM: '8',
    SETTING_MIN_POST_USER_TAG_PER_ITEM: '0',
    SETTING_MAX_POST_USER_TAG_TOTAL: '40',
    SETTING_MIN_POST_USER_TAG_TOTAL: '0',
    SETTING_MAX_POST_DISPLAY_CONTENT_ITEM_FILE_SIZE: '5',
    SETTING_SUPPORTED_POST_DISPLAY_CONTENT_ITEM_FILE_FORMAT: 'png, jpg, jpeg, webp, bmp',

    /*
    |--------------------------------------------------------------------------
    | post comment
    |--------------------------------------------------------------------------
    */

    SETTING_MAX_LEN_POST_COMMENT_DISPLAY_TEXT: '1500',
    SETTING_MIN_LEN_POST_COMMENT_DISPLAY_TEXT: '1',

    /*
    |--------------------------------------------------------------------------
    | collection
    |--------------------------------------------------------------------------
    */

    SETTING_MAX_LEN_COLLECTION_DISPLAY_TITLE: '50',
    SETTING_MIN_LEN_COLLECTION_DISPLAY_TITLE: '1',
  };

  /*
  |--------------------------------------------------------------------------
  | currently active settings
  |--------------------------------------------------------------------------
  */

  static var _active = <String, String>{};

  /*
  |--------------------------------------------------------------------------
  | init
  |--------------------------------------------------------------------------
  */

  static init(ApiRepository repository) {
    if (_isReady) return;
    _isReady = true;

    apiRepository = repository;
    refresh();
  }

  /*
  |--------------------------------------------------------------------------
  | setting value lookups
  |--------------------------------------------------------------------------
  */

  static int getInt(String key) {
    if (_active.containsKey(key)) {
      return AppUtils.intVal(_active[key]!);
    }

    return AppUtils.intVal(_default[key]!);
  }

  static String getString(String key) {
    if (_active.containsKey(key)) {
      return _active[key]!;
    }

    return _default[key]!;
  }

  /*
  |--------------------------------------------------------------------------
  | fetch settings from server and apply them
  |--------------------------------------------------------------------------
  */

  static void refresh() async {
    try {
      var responseModel =
          await apiRepository.preparedRequest(requestType: REQ_TYPE_MISC_SETTINGS, requestData: {});

      if (responseModel.isResponse) {
        _active = Map<String, String>.from(responseModel.content);
      }
    } catch (e) {
      AppLogger.exception(e);
    }
  }
}
