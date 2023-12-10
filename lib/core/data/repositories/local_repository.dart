import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class LocalRepository {
  /*
  |--------------------------------------------------------------------------
  | local provider
  |--------------------------------------------------------------------------
  */

  late final _localProvider = LocalProvider();

  LocalRepository() {
    AppLogger.info("LocalRepository: Init");
  }

  /*
  |--------------------------------------------------------------------------
  | for storing json documents
  |--------------------------------------------------------------------------
  */

  Future<String> get _localPath async => (await getApplicationDocumentsDirectory()).path;

  Future<File> getlocalFile(String fileName) async => File('${await _localPath}/$fileName.json');

  /*
  |--------------------------------------------------------------------------
  | app misc requests:
  |--------------------------------------------------------------------------
  */

  /// get theme
  Future<String?> getThemeTitle() => _localProvider.getThemeTitle();

  // save theme
  void saveThemeTitle(String theme) => _localProvider.saveThemeTitle(theme);

  /// get theme mode
  Future<AppThemeMode> getThemeMode() => _localProvider.getThemeMode();

  // save theme mode
  void saveThemeMode(AppThemeMode mode) => _localProvider.saveThemeMode(mode);

  /*
  |--------------------------------------------------------------------------
  | current user requests
  |--------------------------------------------------------------------------
  */

  /// Delete user model from local storage(if exists)
  void deleteCurrentUser() => _localProvider.deleteUserModel();

  /// Save the user model to local storage
  void saveCurrentUser(UserModel userModel) => _localProvider.saveUserModel(userModel);

  /// Read user model from local storage(if exists)
  Future<UserModel> readCurrentUser() async => _localProvider.readSavedUserModel();
}
