import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class PostSaveModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _savedPostId;
  late String _savedByUserId;
  late String _savedToCollectionId;

  // stamps

  late String _stampRegistration;
  late String _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // ids

  String get savedPostId => _savedPostId;
  String get savedByUserId => _savedByUserId;
  String get savedToCollectionId => _savedToCollectionId;

  // stamps

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  PostSaveModel();

  factory PostSaveModel.none() => PostSaveModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  PostSaveModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary key as int
      _intId = AppUtils.intVal(jsonMap[PostSaveTable.id]);

      _stringId = jsonMap[PostSaveTable.id];

      // ids

      _savedPostId = jsonMap[PostSaveTable.savedPostId];
      _savedByUserId = jsonMap[PostSaveTable.savedByUserId];
      _savedToCollectionId = jsonMap[PostSaveTable.savedToCollectionId];

      // stamps

      _stampRegistration = jsonMap[PostSaveTable.stampRegistration];
      _stampLastUpdate = jsonMap[PostSaveTable.stampLastUpdate];

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

        PostSaveTable.id: id,

        // ids

        PostSaveTable.savedPostId: savedPostId,
        PostSaveTable.savedByUserId: savedByUserId,
        PostSaveTable.savedToCollectionId: savedToCollectionId,

        // stamp

        PostSaveTable.stampRegistration: stampRegistration,
        PostSaveTable.stampLastUpdate: stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as PostSaveModel;

    // ids

    _savedPostId = receivedModel.savedPostId;
    _savedByUserId = receivedModel.savedByUserId;
    _savedToCollectionId = receivedModel.savedToCollectionId;

    // stamps

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;
  }
}
