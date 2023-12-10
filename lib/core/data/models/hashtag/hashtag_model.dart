import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class HashtagModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // display

  late String _displayText;

  // cache

  late int _cachePostsCount;

  // stamp

  late String _stampRegistration;
  late String _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // display

  String get displayText => _displayText;

  // cache

  int get cachePostsCount => _cachePostsCount;

  // stamp

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  HashtagModel();

  factory HashtagModel.none() => HashtagModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  HashtagModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary key

      _intId = AppUtils.intVal(jsonMap[HashtagTable.id]);
      _stringId = jsonMap[HashtagTable.id];

      // display

      _displayText = jsonMap[HashtagTable.displayText];

      // cache

      _cachePostsCount = AppUtils.intVal(jsonMap[HashtagTable.cachePostsCount]);

      // stamps

      _stampRegistration = jsonMap[HashtagTable.stampRegistration];
      _stampLastUpdate = jsonMap[HashtagTable.stampLastUpdate];

      isModel = true;

      /*
      |--------------------------------------------------------------------------
      | failed
      |--------------------------------------------------------------------------
      */
    } catch (e) {
      AppLogger.info(e, logType: AppLogType.parser);
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        HashtagTable.id: id,

        HashtagTable.displayText: displayText,

        // cache

        HashtagTable.cachePostsCount: cachePostsCount,

        // stamp

        HashtagTable.stampRegistration: stampRegistration,
        HashtagTable.stampLastUpdate: stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as HashtagModel;

    // display

    _displayText = receivedModel.displayText;

    // cache

    _cachePostsCount = receivedModel.cachePostsCount;

    // stamps

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;

    // gracefully handle model state updates

    if (!_following && receivedModel.isFollowing) {
      _following = true;
    }
  }

  /*
  |--------------------------------------------------------------------------
  | client specific implementations
  |--------------------------------------------------------------------------
  */

  var _following = false;

  bool get isFollowing => _following;
  bool get isNotFollowing => !_following;

  void setFollowing(bool setTo) => _following = setTo;
}
