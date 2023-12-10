import 'dart:math';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class PgDataUtils {
  static UserModel userModelFromResponse(ResponseModel responseModel) {
    if (responseModel.message != SUCCESS_MSG) {
      return UserModel.none();
    }

    if (!responseModel.contains(UserTable.tableName)) {
      return UserModel.none();
    }

    return UserModel.fromJson(responseModel.first(UserTable.tableName));
  }

  static UserRecoveryModel userRecoveryModelFromResponse(ResponseModel responseModel) {
    if (responseModel.message != SUCCESS_MSG) {
      return UserRecoveryModel.none();
    }

    if (!responseModel.contains(UserRecoveryTable.tableName)) {
      return UserRecoveryModel.none();
    }

    return UserRecoveryModel.fromJson(responseModel.first(UserRecoveryTable.tableName));
  }

  static UserEmailVerificationModel userEmailVerificationModelFromResponse(ResponseModel responseModel) {
    if (responseModel.message != SUCCESS_MSG) {
      return UserEmailVerificationModel.none();
    }

    if (!responseModel.contains(UserEmailVerificationTable.tableName)) {
      return UserEmailVerificationModel.none();
    }

    return UserEmailVerificationModel.fromJson(responseModel.first(UserEmailVerificationTable.tableName));
  }

  static HashtagModel hashtagModelFromResponse(ResponseModel responseModel) {
    if (responseModel.message != SUCCESS_MSG) {
      return HashtagModel.none();
    }

    if (!responseModel.contains(HashtagTable.tableName)) {
      return HashtagModel.none();
    }

    return HashtagModel.fromJson(responseModel.first(HashtagTable.tableName));
  }

  static String random([int length = 6]) => String.fromCharCodes(Iterable.generate(
      length,
      (_) => 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890'
          .codeUnitAt((Random()).nextInt('AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890'.length))));
}
