import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class UserBlockModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _blockedUserId;
  late String _blockedByUserId;

  // stamp

  late String _stampRegistration;
  late String _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // ids

  String get blockedUserId => _blockedUserId;
  String get blockedByUserId => _blockedByUserId;

  // stamp

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  UserBlockModel();

  factory UserBlockModel.none() => UserBlockModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  UserBlockModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary key

      _intId = AppUtils.intVal(jsonMap[UserBlockTable.id]);
      _stringId = jsonMap[UserBlockTable.id];

      // ids

      _blockedUserId = jsonMap[UserBlockTable.blockedUserId];
      _blockedByUserId = jsonMap[UserBlockTable.blockedByUserId];

      // stamp

      _stampRegistration = jsonMap[UserBlockTable.stampRegistration];
      _stampLastUpdate = jsonMap[UserBlockTable.stampLastUpdate];

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
        UserBlockTable.id: id,
        UserBlockTable.blockedUserId: blockedUserId,
        UserBlockTable.blockedByUserId: blockedByUserId,
        UserBlockTable.stampRegistration: stampRegistration,
        UserBlockTable.stampLastUpdate: stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as UserBlockModel;

    // ids

    _blockedUserId = receivedModel.blockedUserId;
    _blockedByUserId = receivedModel.blockedByUserId;

    // stamp

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;
  }
}
