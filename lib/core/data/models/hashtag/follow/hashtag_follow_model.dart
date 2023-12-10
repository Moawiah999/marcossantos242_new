import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class HashtagFollowModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _followedHashtagId;
  late String _followedByUserId;

  // stamp

  late String _stampRegistration;
  late String _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // ids

  String get followedHashtagId => _followedHashtagId;
  String get followedByUserId => _followedByUserId;

  // stamp

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  HashtagFollowModel();

  factory HashtagFollowModel.none() => HashtagFollowModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  HashtagFollowModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary key

      _intId = AppUtils.intVal(jsonMap[HashtagFollowTable.id]);
      _stringId = jsonMap[HashtagFollowTable.id];

      // ids

      _followedHashtagId = jsonMap[HashtagFollowTable.followedHashtagId];
      _followedByUserId = jsonMap[HashtagFollowTable.followedByUserId];

      // stamps

      _stampRegistration = jsonMap[HashtagFollowTable.stampRegistration];
      _stampLastUpdate = jsonMap[HashtagFollowTable.stampLastUpdate];

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

  Map<String, String> toJson() => <String, String>{
        HashtagFollowTable.id: id,
        HashtagFollowTable.followedHashtagId: followedHashtagId,
        HashtagFollowTable.followedByUserId: followedByUserId,
        HashtagFollowTable.stampRegistration: stampRegistration,
        HashtagFollowTable.stampLastUpdate: stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as HashtagFollowModel;

    // ids

    _followedHashtagId = receivedModel.followedHashtagId;
    _followedByUserId = receivedModel.followedByUserId;

    // stamps

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;
  }
}
