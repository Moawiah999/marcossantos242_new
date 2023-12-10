import 'dart:convert';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

import 'package:http/http.dart' as http;

class ApiProvider {
  late final Uri _apiUrl;
  late final String _apiVersion;

  final _client = http.Client();

  var _cookiesHeader = "";
  final _cookies = <String, String>{};

  final _attachments = <String, FileDetails>{};

  /*
  |--------------------------------------------------------------------------
  | constructor, setup end point details
  |--------------------------------------------------------------------------
  */

  ApiProvider({
    required String apiUrl,
    required String apiVersion,
  }) {
    _apiUrl = Uri.parse(apiUrl);
    _apiVersion = apiVersion;
  }

  /*
  |--------------------------------------------------------------------------
  | helpers
  |--------------------------------------------------------------------------
  */

  void addAttachment(String key, FileDetails fileDetails) {
    _attachments[key] = fileDetails;
  }

  void clearAttachments() {
    _attachments.clear();
  }

  bool isAttachmentKeyAvailable(String key) => _attachments.containsKey(key);

  void addCookie(String key, String value) {
    _cookies[key] = value;

    _cookiesHeader = _generateCookieHeader();
  }

  void removeCookie(String key) {
    _cookies.remove(key);

    _cookiesHeader = _generateCookieHeader();
  }

  /*
  |--------------------------------------------------------------------------
  | multipart request:
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> _makeMultiPartRequest(Map<String, dynamic> body) async {
    AppLogger.info("ApiProvider: Request(Multipart) => ", error: json.encode(body));

    var jsonMap = <String, dynamic>{};

    var request = http.MultipartRequest('POST', _apiUrl);

    var postBody = <String, dynamic>{RequestTable.apiVersion: _apiVersion};

    try {
      postBody.addAll(body);

      request.headers["cookie"] = _cookiesHeader;

      request.fields.addAll(
        postBody.map(
          (key, value) => MapEntry(
            key.toString(),
            jsonEncode(value),
          ),
        ),
      );

      _attachments.forEach((randomName, fileDetails) {
        // root
        var namespace = RestTable.attachments;

        // intermediate
        if (fileDetails.namespace.isNotEmpty) {
          namespace += "[${fileDetails.namespace}]";
        }

        // leaf
        namespace += "[${fileDetails.fieldName}]";

        // multiple files in at same leaf node
        if (fileDetails.addIsCollection) {
          namespace += '[]';
        }

        request.files.add(
          http.MultipartFile.fromBytes(
            namespace,
            fileDetails.bytes,
            filename: fileDetails.fieldName,
            contentType: fileDetails.mediaType,
          ),
        );
      });

      var response = await request.send();

      _updateHeaderSetCookie(response.headers['set-cookie']);

      var responseData = await response.stream.toBytes();

      jsonMap = Map<String, dynamic>.from(jsonDecode(utf8.decode(responseData)));
    } catch (e) {
      AppLogger.exception(e);
    } finally {
      clearAttachments();
    }

    return ResponseModel.fromJson(jsonMap);
  }

  /*
  |--------------------------------------------------------------------------
  | post request:
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> _makeRequest({
    required String requestType,
    required Map<String, dynamic> body,
  }) async {
    AppLogger.info("ApiProvider: Request($requestType) => ", error: json.encode(body));

    var jsonMap = <String, dynamic>{};

    var postBody = {};

    postBody.addAll({
      RequestTable.apiVersion: _apiVersion,
      RequestTable.reqType: requestType,
    });

    postBody.addAll({RequestTable.payload: body});

    try {
      var response = await _client.post(
        _apiUrl,
        body: json.encode(postBody),
        headers: {
          "content-type": "application/json",
          "cookie": _cookiesHeader,
        },
      );

      _updateHeaderSetCookie(response.headers['set-cookie']);

      jsonMap = Map<String, dynamic>.from(jsonDecode(utf8.decode(response.bodyBytes)));
    } catch (e) {
      if (e is http.ClientException && e.message == 'Connection closed before full header was received') {
        //
        // It's an official issue. Happens on few devices, and occurrence is very rare.
        //
        // 1. https://github.com/flutter/flutter/issues/41573
        // 2. https://github.com/flutter/flutter/issues/58676
        //
        // All libraries are impacted, especially Dio and http.
        //
        // Workaround here is to retry request. Please note that client can see some inconsitent
        // results if request we tried is not idempotent. But as mentioned in threads above, exception
        // is thrown when engine tries to send multiple requests. In our App, this can happen when
        // user loads contents, scrolls very fast or things like that. Luckly all these requests
        // are idempotent. Requests that are not idempotent, are sent as singular(update name etc)
        // , and those won't throw this exception.
        //
        // At the point of writing(18 Feb 2022), issue is still open. We'll patch this part when Flutter
        // team announces the fix. Until then we'll stick to retry at least one time.
        //

        try {
          var response = await _client.post(
            _apiUrl,
            body: json.encode(postBody),
            headers: {
              "content-type": "application/json",
              "cookie": _cookiesHeader,
            },
          );

          _updateHeaderSetCookie(response.headers['set-cookie']);

          jsonMap = Map<String, dynamic>.from(jsonDecode(utf8.decode(response.bodyBytes)));
        } catch (e) {
          AppLogger.exception(e);
        }
      } else {
        AppLogger.exception(e);
      }
    }

    return ResponseModel.fromJson(jsonMap);
  }

  /*
  |--------------------------------------------------------------------------
  | prepared request:
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> preparedRequest({
    required String requestType,
    required Map<String, dynamic> requestData,
  }) async =>
      await _makeRequest(
        requestType: requestType,
        body: requestData,
      );

  String _generateCookieHeader() {
    String cookie = "";

    for (var key in _cookies.keys) {
      if (cookie.isNotEmpty) cookie += ";";

      cookie += key + "=" + _cookies[key]!;
    }

    return cookie;
  }

  void _updateHeaderSetCookie(String? setCookieHeader) {
    if (setCookieHeader != null) {
      var setCookies = setCookieHeader.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setRawCookie(cookie);
        }
      }

      _cookiesHeader = _generateCookieHeader();
    }
  }

  void _setRawCookie(String? rawCookie) {
    if (rawCookie != null) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;

        _cookies[key] = value;
      }
    }
  }

  /*
  |--------------------------------------------------------------------------
  | auth session request:
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> authSession() async => await _makeRequest(requestType: REQ_TYPE_SESSION, body: {});

  /*
  |--------------------------------------------------------------------------
  | login request:
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> login({
    required String username,
    required String password,
  }) async =>
      await _makeRequest(
        requestType: REQ_TYPE_LOGIN,
        body: {
          UserTable.tableName: {
            UserTable.username: username,
            UserTable.password: password,
          },
        },
      );

  /*
  |--------------------------------------------------------------------------
  | upload user's profile picture request:
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> uploadUserProfilePicture() async => await _makeMultiPartRequest(
        {
          RequestTable.reqType: REQ_TYPE_UPLOAD_USER_PROFILE_PICTURE,
        },
      );

  /*
  |--------------------------------------------------------------------------
  | submit new post request
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> submitPost({
    required Map<String, dynamic> payload,
  }) async =>
      await _makeMultiPartRequest(
        {
          RequestTable.reqType: REQ_TYPE_POST_ADD,
          RequestTable.payload: payload,
        },
      );
}
