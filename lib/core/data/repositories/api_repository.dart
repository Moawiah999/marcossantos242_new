import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class ApiRepository {
  static ApiRepository of(BuildContext context) => AppProvider.of(context).apiRepo;

  /*
  |--------------------------------------------------------------------------
  | api provider
  |--------------------------------------------------------------------------
  */

  final ApiProvider _apiProvider = ApiProvider(apiUrl: '${APP_SERVER_URL}api/', apiVersion: APP_API_VERSION);

  ApiRepository() {
    AppLogger.info("ApiRepository: Init");
  }

  /*
  |--------------------------------------------------------------------------
  | cookies
  |--------------------------------------------------------------------------
  */

  void addCookie(String key, String value) => _apiProvider.addCookie(key, value);
  void removeCookie(String key) => _apiProvider.removeCookie(key);

  /*
  |--------------------------------------------------------------------------
  | temporary files will be sent on next request and will be removed after that
  |--------------------------------------------------------------------------
  */

  void attachFile(FileDetails fileDetails) {
    // generate random key
    var randomKey = PgUtils.random();

    while (_apiProvider.isAttachmentKeyAvailable(randomKey)) {
      randomKey = PgUtils.random();
    }

    _apiProvider.addAttachment(randomKey, fileDetails);
  }

  void clearAttachments() {
    _apiProvider.clearAttachments();
  }

  /*
  |--------------------------------------------------------------------------
  | prepared request
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> preparedRequest({
    required String requestType,
    required Map<String, dynamic> requestData,
  }) async =>
      _apiProvider.preparedRequest(
        requestType: requestType,
        requestData: requestData,
      );

  /*
  |--------------------------------------------------------------------------
  | auth session request
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> authSession() async => _apiProvider.authSession();

  /*
  |--------------------------------------------------------------------------
  | login request
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> login({
    required String username,
    required String password,
  }) async =>
      _apiProvider.login(
        username: username,
        password: password,
      );

  /*
  |--------------------------------------------------------------------------
  | remove user's profile picture request
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> removeUserProfilePicture({
    required String userId,
  }) async =>
      _apiProvider.preparedRequest(
        requestType: REQ_TYPE_REMOVE_USER_PROFILE_PICTURE,
        requestData: {
          UserTable.tableName: {
            UserTable.id: userId,
          },
        },
      );

  /*
  |--------------------------------------------------------------------------
  | upload user's profile picture request
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> uploadUseProfilePicture({
    required Uint8List fileBytes,
  }) async {
    // generate file details
    var fileDetails = FileDetails(
      bytes: fileBytes,
      fieldName: UserTable.displayImage,
      namespace: UserTable.tableName,
      mediaType: MediaType('image', 'png'),
    );

    clearAttachments();

    // add image as temporary file
    attachFile(fileDetails);

    // send multi part request
    return _apiProvider.uploadUserProfilePicture();
  }

  /*
  |--------------------------------------------------------------------------
  | post like request
  |--------------------------------------------------------------------------
  */

  Future<bool> postLikeActionAdd({
    required bool doLike,
    required PostModel postModel,
  }) async {
    var responseModel = await _apiProvider.preparedRequest(
      requestType: doLike ? REQ_TYPE_POST_LIKE_ADD : REQ_TYPE_POST_LIKE_REMOVE,
      requestData: {
        PostLikeTable.tableName: {PostLikeTable.likedPostId: postModel.intId}
      },
    );

    // check request response
    if (responseModel.isResponse && responseModel.message == SUCCESS_MSG) {
      if (!doLike) return true;

      if (responseModel.contains(PostLikeTable.tableName)) {
        var postLikeModel = PostLikeModel.fromJson(responseModel.first(PostLikeTable.tableName));

        if (postLikeModel.isModel) return true;
      }
    }

    // something went wrong, revert changes
    return false;
  }

  /*
  |--------------------------------------------------------------------------
  | post comment like request
  |--------------------------------------------------------------------------
  */

  Future<bool> postCommentLikeActionAdd({
    required bool doLike,
    required PostCommentModel postCommentModel,
  }) async {
    var responseModel = await _apiProvider.preparedRequest(
      requestType: doLike ? REQ_TYPE_POST_COMMENT_LIKE_ADD : REQ_TYPE_POST_COMMENT_LIKE_REMOVE,
      requestData: {
        PostCommentLikeTable.tableName: {PostCommentLikeTable.likedPostCommentId: postCommentModel.intId}
      },
    );

    // check request response
    if (responseModel.isResponse && responseModel.message == SUCCESS_MSG) {
      if (!doLike) return true;

      if (responseModel.contains(PostCommentLikeTable.tableName)) {
        var postCommentLikeModel = PostCommentLikeModel.fromJson(responseModel.first(PostCommentLikeTable.tableName));

        if (postCommentLikeModel.isModel) return true;
      }
    }

    // something went wrong, revert changes
    return false;
  }

  /*
  |--------------------------------------------------------------------------
  | post save request
  |--------------------------------------------------------------------------
  */

  Future<bool> postSaveActionAdd({
    required bool doSave,
    required PostModel postModel,
  }) async {
    var responseModel = await _apiProvider.preparedRequest(
      requestType: doSave ? REQ_TYPE_POST_SAVE_ADD : REQ_TYPE_POST_SAVE_REMOVE,
      requestData: {
        PostSaveTable.tableName: {PostSaveTable.savedPostId: postModel.intId}
      },
    );

    // check request response
    if (responseModel.isResponse && responseModel.message == SUCCESS_MSG) {
      if (!doSave) return true;

      if (responseModel.contains(PostSaveTable.tableName)) {
        var postSaveModel = PostSaveModel.fromJson(responseModel.first(PostSaveTable.tableName));

        if (postSaveModel.isModel) return true;
      }
    }

    // something went wrong, revert changes
    return false;
  }

  /*
  |--------------------------------------------------------------------------
  | user follow request
  |--------------------------------------------------------------------------
  */

  Future<bool> userFollowActionAdd({required bool doFollow, required UserModel userModel}) async {
    var responseModel = await _apiProvider.preparedRequest(
      requestType: doFollow ? REQ_TYPE_USER_FOLLOW_ADD : REQ_TYPE_USER_FOLLOW_REMOVE,
      requestData: {
        UserTable.tableName: {UserTable.id: userModel.intId}
      },
    );

    // check request response
    if (responseModel.isResponse && responseModel.message == SUCCESS_MSG) {
      if (!doFollow) return true;

      if (responseModel.contains(UserFollowTable.tableName)) {
        var followModel = UserFollowModel.fromJson(responseModel.first(UserFollowTable.tableName));

        if (followModel.isModel) return true;
      }
    }

    // something went wrong, revert changes
    return false;
  }

  /*
  |--------------------------------------------------------------------------
  | user follow request
  |--------------------------------------------------------------------------
  */

  Future<bool> userBlockActionAdd({required bool doBlock, required UserModel userModel}) async {
    var responseModel = await _apiProvider.preparedRequest(
      requestType: doBlock ? REQ_TYPE_USER_BLOCK_ADD : REQ_TYPE_USER_BLOCK_REMOVE,
      requestData: {
        UserTable.tableName: {UserTable.id: userModel.intId}
      },
    );

    // check request response
    if (responseModel.isResponse && responseModel.message == SUCCESS_MSG) {
      if (!doBlock) return true;

      if (responseModel.contains(UserBlockTable.tableName)) {
        var model = UserBlockModel.fromJson(responseModel.first(UserBlockTable.tableName));

        if (model.isModel) return true;
      }
    }

    // something went wrong, revert changes
    return false;
  }

  /*
  |--------------------------------------------------------------------------
  | user set account privacy request
  |--------------------------------------------------------------------------
  */

  Future<bool> userUpdateAccountPrivacy({required String metaIsPrivate}) async {
    var responseModel = await _apiProvider.preparedRequest(
      requestType: REQ_TYPE_UPDATE_USER_META_IS_PRIVATE,
      requestData: {
        UserTable.tableName: {UserTable.metaIsPrivate: metaIsPrivate}
      },
    );

    // check request response
    if (responseModel.isResponse && responseModel.message == SUCCESS_MSG) {
      if (responseModel.contains(UserTable.tableName)) {
        var model = UserModel.fromJson(responseModel.first(UserTable.tableName));

        // ensure received value is the one we tried to set
        return metaIsPrivate == model.metaIsPrivate;
      }
    }

    // something went wrong, revert changes
    return false;
  }

  /*
  |--------------------------------------------------------------------------
  | user set new push settings
  |--------------------------------------------------------------------------
  */

  Future<void> userUpdateMetaPushSettings({required UserMetaPushSettingsDTO userPushSettingsDTO}) async {
    await _apiProvider.preparedRequest(
      requestType: REQ_TYPE_UPDATE_USER_META_PUSH_SETTINGS,
      requestData: {
        UserTable.tableName: {UserTable.metaPushSettings: userPushSettingsDTO}
      },
    );
  }

  /*
  |--------------------------------------------------------------------------
  | submit new post request
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> postActionAdd({
    required String postDisplayCaption,
    required String postDisplayLocation,
    required List<PostContentImage> images,
  }) async {
    clearAttachments();

    var taggedUsers = <List<PostDisplayUserTagDTO>>[];

    for (var image in images) {
      attachFile(
        FileDetails(
          bytes: image.getImageBytes,
          fieldName: PostTable.displayContent,
          namespace: PostTable.tableName,
          mediaType: MediaType('image', 'png'),
          addIsCollection: true,
        ),
      );

      taggedUsers.add(image.displayUserTagsOnImage);
    }

    return _apiProvider.submitPost(payload: {
      PostTable.tableName: {
        PostTable.displayCaption: postDisplayCaption,
        PostTable.displayLocation: postDisplayLocation,
        PostTable.displayContent: taggedUsers,
      }
    });
  }

  /*
  |--------------------------------------------------------------------------
  | delete post request
  |--------------------------------------------------------------------------
  */

  Future<bool> deletePost({
    required PostModel postModel,
  }) async {
    var responseModel = await _apiProvider.preparedRequest(
      requestType: REQ_TYPE_POST_REMOVE,
      requestData: {
        PostTable.tableName: {PostTable.id: postModel.intId}
      },
    );

    return (responseModel.isResponse && responseModel.message == SUCCESS_MSG);
  }

  /*
  |--------------------------------------------------------------------------
  | hashtag follow request
  |--------------------------------------------------------------------------
  */

  Future<bool> followHashtag({required bool doFollow, required HashtagModel hashtagModel}) async {
    var responseModel = await _apiProvider.preparedRequest(
      requestType: doFollow ? REQ_TYPE_HASHTAG_FOLLOW_ADD : REQ_TYPE_HASHTAG_FOLLOW_REMOVE,
      requestData: {
        HashtagFollowTable.tableName: {HashtagFollowTable.followedHashtagId: hashtagModel.intId}
      },
    );

    // check request response
    if (responseModel.isResponse && responseModel.message == SUCCESS_MSG) {
      if (!doFollow) return true;

      if (responseModel.contains(HashtagFollowTable.tableName)) {
        var hashtagFollowModel = HashtagFollowModel.fromJson(responseModel.first(HashtagFollowTable.tableName));

        if (hashtagFollowModel.isModel) return true;
      }
    }

    // something went wrong, revert changes
    return false;
  }

  /*
  |--------------------------------------------------------------------------
  | single item requests
  |--------------------------------------------------------------------------
  */

  Future<ResponseModel> userById({
    required String userId,
  }) async =>
      _apiProvider.preparedRequest(
        requestType: REQ_TYPE_USER_LOAD_SINGLE,
        requestData: {
          UserTable.tableName: {UserTable.id: userId},
        },
      );

  Future<ResponseModel> userByUsername({
    required String username,
  }) async =>
      _apiProvider.preparedRequest(
        requestType: REQ_TYPE_USER_LOAD_SINGLE,
        requestData: {
          UserTable.tableName: {UserTable.username: username},
        },
      );

  Future<ResponseModel> postById({
    required String postId,
  }) async =>
      _apiProvider.preparedRequest(
        requestType: REQ_TYPE_POST_LOAD_SINGLE,
        requestData: {
          PostTable.tableName: {PostTable.id: postId},
        },
      );

  Future<ResponseModel> hashtagById({
    required String hashtagId,
  }) async =>
      _apiProvider.preparedRequest(
        requestType: REQ_TYPE_HASHTAG_LOAD_SINGLE,
        requestData: {
          HashtagTable.tableName: {HashtagTable.id: hashtagId},
        },
      );

  Future<ResponseModel> hashtagByDisplayText({
    required String hashtag,
  }) async =>
      _apiProvider.preparedRequest(
        requestType: REQ_TYPE_HASHTAG_LOAD_SINGLE,
        requestData: {
          HashtagTable.tableName: {HashtagTable.displayText: hashtag},
        },
      );
}
