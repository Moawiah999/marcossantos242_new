import 'package:photogram/import/data.dart';

class ResponseModel {
  // in-built error detection
  late final bool isResponse;

  late final Map<String, dynamic> _response;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  bool get isNotResponse => !isResponse;

  String get message => isNotResponse ? '' : _response[ResponseTable.message];

  Map<String, dynamic> get content => isNotResponse ? {} : _response[ResponseTable.content];

  Map<String, dynamic> get additionalContent {
    if (content.containsKey(RestTable.additionalObjects)) {
      return content[RestTable.additionalObjects];
    }

    return {};
  }

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  ResponseModel.fromJson(Map<String, dynamic> jsonMap) {
    try {
      /*
      |--------------------------------------------------------------------------
      | try setting all fields:
      |--------------------------------------------------------------------------
      */

      _response = {
        ResponseTable.content: jsonMap[RestTable.response][ResponseTable.content],
        ResponseTable.message: jsonMap[RestTable.response][ResponseTable.message],
      };

      isResponse = true;

      /*
      |--------------------------------------------------------------------------
      | failed
      |--------------------------------------------------------------------------
      */
    } catch (_) {
      isResponse = false;
    }
  }

  /*
  |--------------------------------------------------------------------------
  | helpers:
  |--------------------------------------------------------------------------
  */

  bool contains(String namespace) => content.containsKey(namespace);

  Map<String, dynamic> first(String namespace) => Map<String, dynamic>.from(content[namespace][0]);
}
