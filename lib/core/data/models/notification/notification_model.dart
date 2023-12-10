import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class NotificationModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _toUserId;

  // linked content

  late NotificationLinkedContentDTO _linkedContent;

  // meta

  late String _metaType;
  late String _metaIsRead;

  // stamps

  late String _stampRegistration;
  late String _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  // ids

  String get toUserId => _toUserId;

  // linked content

  NotificationLinkedContentDTO get linkedContent => _linkedContent;

  // meta

  String get metaType => _metaType;
  String get metaIsRead => _metaIsRead;

  // stamps

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  // helper getters

  bool get isRead => metaIsRead == NotificationEnum.metaIsReadYes;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  NotificationModel();

  factory NotificationModel.none() => NotificationModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  NotificationModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */

    try {
      // primary key

      _intId = AppUtils.intVal(jsonMap[NotifcationTable.id]);
      _stringId = jsonMap[NotifcationTable.id];

      // ids

      _toUserId = jsonMap[NotifcationTable.toUserId];

      // linked content

      _linkedContent = NotificationLinkedContentDTO.fromJson(jsonMap[NotifcationTable.linkedContent]);

      // meta

      _metaType = jsonMap[NotifcationTable.metaType];
      _metaIsRead = jsonMap[NotifcationTable.metaIsRead];

      // stamps

      _stampRegistration = jsonMap[NotifcationTable.stampRegistration];
      _stampLastUpdate = jsonMap[NotifcationTable.stampLastUpdate];

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

        NotifcationTable.id: id,

        // ids

        NotifcationTable.toUserId: _toUserId,

        // linked content

        NotifcationTable.linkedContent: _linkedContent.toJson(),

        // meta

        NotifcationTable.metaType: _metaType,
        NotifcationTable.metaIsRead: _metaIsRead,

        // stamps

        NotifcationTable.stampRegistration: _stampRegistration,
        NotifcationTable.stampLastUpdate: _stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as NotificationModel;

    // ids

    _toUserId = receivedModel.toUserId;

    // linked content

    _linkedContent = receivedModel.linkedContent;

    // meta

    _metaType = receivedModel.metaType;
    _metaIsRead = receivedModel.metaIsRead;

    // stamps

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;
  }
}
