import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class UserRecoveryModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _userId;

  // meta

  late String _metaAccessToken;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // ids

  String get userId => _userId;

  // meta

  String get metaAccessToken => _metaAccessToken;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  UserRecoveryModel();

  factory UserRecoveryModel.none() => UserRecoveryModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  UserRecoveryModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary key

      _intId = AppUtils.intVal(jsonMap[UserRecoveryTable.id]);
      _stringId = jsonMap[UserRecoveryTable.id];

      // ids

      _userId = jsonMap[UserRecoveryTable.userId];

      // meta

      _metaAccessToken = jsonMap[UserRecoveryTable.metaAccessToken];

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
        // primary key

        UserRecoveryTable.id: id,

        // ids

        UserRecoveryTable.userId: userId,

        // meta

        UserRecoveryTable.metaAccessToken: _metaAccessToken,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as UserRecoveryModel;

    // ids

    _userId = receivedModel.userId;

    // meta

    _metaAccessToken = receivedModel.metaAccessToken;
  }
}
