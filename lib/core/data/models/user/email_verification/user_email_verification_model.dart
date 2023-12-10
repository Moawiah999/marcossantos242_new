import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class UserEmailVerificationModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _userId;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // ids

  String get userId => _userId;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  UserEmailVerificationModel();

  factory UserEmailVerificationModel.none() => UserEmailVerificationModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  UserEmailVerificationModel.fromJson(Map<String, dynamic> jsonMap) {
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
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as UserEmailVerificationModel;

    // ids

    _userId = receivedModel.userId;
  }
}
