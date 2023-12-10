import 'dart:convert';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalProvider {
  var _ready = false;
  late SharedPreferences _preferences;

  /*
  |--------------------------------------------------------------------------
  | app misc requests:
  |--------------------------------------------------------------------------
  */

  Future<String?> getThemeTitle() async {
    try {
      var instance = await _getInstance();

      return instance.getString(LITERAL_THEME_TITLE);
    } catch (e) {
      AppLogger.exception(e);
    }
    return null;
  }

  void saveThemeTitle(String theme) async {
    try {
      var instance = await _getInstance();

      instance.setString(LITERAL_THEME_TITLE, theme);
    } catch (e) {
      AppLogger.exception(e);
    }
  }

  Future<AppThemeMode> getThemeMode() async {
    try {
      var instance = await _getInstance();

      var savedThemeMode = instance.getString(LITERAL_THEME_MODE);

      if (null == savedThemeMode) return DEFAULT_THEME_MODE;

      if (savedThemeMode == AppThemeMode.dark.toString()) return AppThemeMode.dark;

      return AppThemeMode.light;
    } catch (e) {
      AppLogger.exception(e);
    }

    return DEFAULT_THEME_MODE;
  }

  void saveThemeMode(AppThemeMode mode) async {
    try {
      var instance = await _getInstance();

      await instance.setString(LITERAL_THEME_MODE, mode.toString());
    } catch (e) {
      AppLogger.exception(e);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | current user requests:
  |--------------------------------------------------------------------------
  */

  Future<UserModel> readSavedUserModel() async {
    var user = UserModel();

    try {
      var instance = await _getInstance();

      var savedUserModel = instance.getString(LITERAL_AUTHED_USER_MODEL);

      if (null != savedUserModel) {
        user = UserModel.fromJson(jsonDecode(savedUserModel));
      }
    } catch (e) {
      AppLogger.exception(e);
    }
    return user;
  }

  void saveUserModel(UserModel userModel) async {
    try {
      var instance = await _getInstance();

      instance.setString(LITERAL_AUTHED_USER_MODEL, jsonEncode(userModel.toJson()));
    } catch (e) {
      AppLogger.exception(e);
    }
  }

  void deleteUserModel() async {
    try {
      var instance = await _getInstance();

      instance.remove(LITERAL_AUTHED_USER_MODEL);
    } catch (e) {
      AppLogger.exception(e);
    }
  }

  Future<SharedPreferences> _getInstance() async {
    if (!_ready) {
      _preferences = await SharedPreferences.getInstance();
      _ready = true;
    }

    return _preferences;
  }
}
