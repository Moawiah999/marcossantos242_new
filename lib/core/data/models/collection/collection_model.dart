import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class CollectionModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _ownerUserId;

  // display

  late String _displayTitle;

  late CollectionDisplayImageDTO _displayImage;

  // stamps

  late String _stampRegistration;
  late String _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // ids

  String get ownerUserId => _ownerUserId;

  // display

  String get displayTitle => _displayTitle;

  CollectionDisplayImageDTO get displayImage => _displayImage;

  String get image => displayImage.urlCompressed;

  // stamps

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  CollectionModel();

  factory CollectionModel.none() => CollectionModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  CollectionModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */

    try {
      // primary key

      _intId = AppUtils.intVal(jsonMap[CollectionTable.id]);
      _stringId = jsonMap[CollectionTable.id];

      // ids

      _ownerUserId = jsonMap[CollectionTable.ownerUserId];

      // display

      _displayTitle = jsonMap[CollectionTable.displayTitle];

      var displayImage = CollectionDisplayImageDTO.fromJson(jsonMap[CollectionTable.displayImage]);

      if (displayImage.isNotDTO) {
        throw Exception();
      }

      _displayImage = displayImage;

      // stamps

      _stampRegistration = jsonMap[CollectionTable.stampRegistration];
      _stampLastUpdate = jsonMap[CollectionTable.stampLastUpdate];

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
        // primary key

        CollectionTable.id: id,

        // ids

        CollectionTable.ownerUserId: ownerUserId,

        // display

        CollectionTable.displayTitle: displayTitle,

        CollectionTable.displayImage: displayImage.toJson(),

        // stamp

        CollectionTable.stampRegistration: stampRegistration,
        CollectionTable.stampLastUpdate: stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as CollectionModel;

    // ids

    _ownerUserId = receivedModel.ownerUserId;

    // display

    _displayTitle = receivedModel.displayTitle;

    _displayImage = receivedModel.displayImage;

    // stamps

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;
  }
}
