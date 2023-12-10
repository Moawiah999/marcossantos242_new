import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class UserFollowModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _followedUserId;
  late String _followedByUserId;

  // meta

  late String _metaIsPending;

  // stamp

  late String _stampRegistration;
  late String _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // ids

  String get followedUserId => _followedUserId;
  String get followedByUserId => _followedByUserId;

  // meta

  String get metaIsPending => _metaIsPending;

  // stamp

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | account privacy related, client added fields
  |--------------------------------------------------------------------------
  */

  var isPending = false;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  UserFollowModel();

  factory UserFollowModel.none() => UserFollowModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  UserFollowModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary key

      _intId = AppUtils.intVal(jsonMap[UserFollowTable.id]);
      _stringId = jsonMap[UserFollowTable.id];

      // ids

      _followedUserId = jsonMap[UserFollowTable.followedUserId];
      _followedByUserId = jsonMap[UserFollowTable.followedByUserId];

      // meta

      _metaIsPending = jsonMap[UserFollowTable.metaIsPending];

      // stamp

      _stampRegistration = jsonMap[UserFollowTable.stampRegistration];
      _stampLastUpdate = jsonMap[UserFollowTable.stampLastUpdate];

      // update internal state(if any)

      setPendingStatus(metaIsPending);

      // done, model is now a valid object

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
        UserFollowTable.id: id,
        UserFollowTable.followedUserId: followedUserId,
        UserFollowTable.followedByUserId: followedByUserId,
        UserFollowTable.metaIsPending: metaIsPending,
        UserFollowTable.stampRegistration: stampRegistration,
        UserFollowTable.stampLastUpdate: stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as UserFollowModel;

    // ids

    _followedUserId = receivedModel.followedUserId;
    _followedByUserId = receivedModel.followedByUserId;

    // meta is pending

    _metaIsPending = receivedModel.metaIsPending;

    // stamp

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;

    // handle model state updates

    setPendingStatus(receivedModel.metaIsPending);
  }

  /*
  |--------------------------------------------------------------------------
  | client specific implementations
  |--------------------------------------------------------------------------
  */

  void setPendingStatus(String toSet) {
    isPending = (UserFollowEnum.metaIsPendingYes == toSet);
  }
}
