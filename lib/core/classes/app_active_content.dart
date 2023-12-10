import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';

class AppActiveContent {
  final BuildContext context;
  late final AppContentProvider _appContentProvider;
  late final String _widgetInstanceId;

  AppActiveContent(this.context) {
    _appContentProvider = AppProvider.of(context).appContentProvider;
    _widgetInstanceId = const Uuid().v1();
  }

  void clear() => _appContentProvider.clearWidget(disposedWidgetInstanceId: _widgetInstanceId);

  void dispose() => _appContentProvider.disposeWidget(disposedWidgetInstanceId: _widgetInstanceId);

  Map<int, T> pagedModels<T>() => _appContentProvider.pagedModels<T>(widgetInstanceId: _widgetInstanceId);

  T? watch<T>(int contentId) => _appContentProvider.watch<T>(
        contentId: contentId,
        widgetInstanceId: _widgetInstanceId,
      );

  T? read<T>(int contentId) => _appContentProvider.read<T>(
        contentId: contentId,
        widgetInstanceId: _widgetInstanceId,
      );

  void unlink<T>(int contentId) => _appContentProvider.unlink<T>(
        contentId: contentId,
        widgetInstanceId: _widgetInstanceId,
      );

  List<int> addOrUpdateListOfModels<T>({List<T> models = const []}) => _appContentProvider.addOrUpdateAll<T>(
        models: models,
        widgetInstanceId: _widgetInstanceId,
      );

  int addOrUpdateModel<T>(T model) => _appContentProvider.addOrUpdateModel<T>(
        model: model,
        widgetInstanceId: _widgetInstanceId,
      );

  /*
  |--------------------------------------------------------------------------
  | blocs
  |--------------------------------------------------------------------------
  */

  AuthBloc get authBloc => AppProvider.of(context).auth;

  ThemeBloc get themeBloc => AppProvider.of(context).theme;

  NavigationBloc get navigationBloc => AppProvider.of(context).navigation;

  ApiRepository get apiRepository => AppProvider.of(context).apiRepo;

  LocalRepository get localRepository => AppProvider.of(context).localRepo;

  /*
  |--------------------------------------------------------------------------
  | handle content
  | 
  | This is our global port that handle most of the responses. Having all 
  | parsing at one place is easier to manage.
  | 
  | !! Important Note !!
  | 
  | This piece of code looks like a lengthy call but it's not. This get's 
  | called to collect data from response. Response part of all requests can
  | contains maximum of 4 different types of models, which means on each call
  | only 4 blocks from all below are going to execute and rest will be skipped
  | Skip is effecient and involves a simple hash map look up. We can easily 
  | introduce concurrency in this part, if it ever needs to be. 
  |--------------------------------------------------------------------------
  */

  void handleResponse(ResponseModel responseModel) => _captureData(responseModel);

  void _captureData(ResponseModel responseModel) {
    try {
      if (END_OF_RESULTS_MSG != responseModel.message) {
        /*
        |--------------------------------------------------------------------------
        | check for users
        |--------------------------------------------------------------------------
        */

        var userModelsToAdd = <int, UserModel>{};

        if (responseModel.content.containsKey(UserTable.tableName)) {
          for (var dataMap in (responseModel.content[UserTable.tableName] as List)) {
            var model = UserModel.fromJson(dataMap);

            if (model.isModel) {
              userModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for posts
        |--------------------------------------------------------------------------
        */

        var postModelsToAdd = <int, PostModel>{};

        if (responseModel.content.containsKey(PostTable.tableName)) {
          for (var dataMap in (responseModel.content[PostTable.tableName] as List)) {
            var model = PostModel.fromJson(dataMap);

            if (model.isModel) {
              postModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for user follow
        |--------------------------------------------------------------------------
        */

        var userFollowModelsToAdd = <int, UserFollowModel>{};

        if (responseModel.content.containsKey(UserFollowTable.tableName)) {
          for (var dataMap in (responseModel.content[UserFollowTable.tableName] as List)) {
            var model = UserFollowModel.fromJson(dataMap);

            if (model.isModel) {
              userFollowModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for user block
        |--------------------------------------------------------------------------
        */

        var userBlockModelsToAdd = <int, UserBlockModel>{};

        if (responseModel.content.containsKey(UserBlockTable.tableName)) {
          for (var dataMap in (responseModel.content[UserBlockTable.tableName] as List)) {
            var model = UserBlockModel.fromJson(dataMap);

            if (model.isModel) {
              userBlockModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for postLike
        |--------------------------------------------------------------------------
        */

        var postLikeModelsToAdd = <int, PostLikeModel>{};

        if (responseModel.content.containsKey(PostLikeTable.tableName)) {
          for (var dataMap in (responseModel.content[PostLikeTable.tableName] as List)) {
            var model = PostLikeModel.fromJson(dataMap);

            if (model.isModel) {
              postLikeModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for postComment
        |--------------------------------------------------------------------------
        */

        var postCommentModelsToAdd = <int, PostCommentModel>{};

        if (responseModel.content.containsKey(PostCommentTable.tableName)) {
          for (var dataMap in (responseModel.content[PostCommentTable.tableName] as List)) {
            var model = PostCommentModel.fromJson(dataMap);

            if (model.isModel) {
              postCommentModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for postSave
        |--------------------------------------------------------------------------
        */

        var postSaveModelsToAdd = <int, PostSaveModel>{};

        if (responseModel.content.containsKey(PostSaveTable.tableName)) {
          for (var dataMap in (responseModel.content[PostSaveTable.tableName] as List)) {
            var model = PostSaveModel.fromJson(dataMap);

            if (model.isModel) {
              postSaveModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for postComment likes
        |--------------------------------------------------------------------------
        */

        var postCommentLikeModelsToAdd = <int, PostCommentLikeModel>{};

        if (responseModel.content.containsKey(PostCommentLikeTable.tableName)) {
          for (var dataMap in (responseModel.content[PostCommentLikeTable.tableName] as List)) {
            var model = PostCommentLikeModel.fromJson(dataMap);

            if (model.isModel) {
              postCommentLikeModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for postusertag models
        |--------------------------------------------------------------------------
        */

        var postUserTagModelsToAdd = <int, PostUserTagModel>{};

        if (responseModel.content.containsKey(PostUserTagTable.tableName)) {
          for (var dataMap in (responseModel.content[PostUserTagTable.tableName] as List)) {
            var model = PostUserTagModel.fromJson(dataMap);

            if (model.isModel) {
              postUserTagModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for collection
        |--------------------------------------------------------------------------
        */

        var collectionModelsToAdd = <int, CollectionModel>{};

        if (responseModel.content.containsKey(CollectionTable.tableName)) {
          for (var dataMap in (responseModel.content[CollectionTable.tableName] as List)) {
            var model = CollectionModel.fromJson(dataMap);

            if (model.isModel) {
              collectionModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for hashtag models
        |--------------------------------------------------------------------------
        */

        var hashtagModelsToAdd = <int, HashtagModel>{};

        if (responseModel.content.containsKey(HashtagTable.tableName)) {
          for (var dataMap in (responseModel.content[HashtagTable.tableName] as List)) {
            var model = HashtagModel.fromJson(dataMap);

            if (model.isModel) {
              hashtagModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for hashtagpost models
        |--------------------------------------------------------------------------
        */

        var hashtagPostModelsToAdd = <int, HashtagPostModel>{};

        if (responseModel.content.containsKey(HashtagPostTable.tableName)) {
          for (var dataMap in (responseModel.content[HashtagPostTable.tableName] as List)) {
            var model = HashtagPostModel.fromJson(dataMap);

            if (model.isModel) {
              hashtagPostModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for notifications
        |--------------------------------------------------------------------------
        */

        var notificationModelsToAdd = <int, NotificationModel>{};

        if (responseModel.content.containsKey(NotifcationTable.tableName)) {
          for (var dataMap in (responseModel.content[NotifcationTable.tableName] as List)) {
            var model = NotificationModel.fromJson(dataMap);

            if (model.isModel) {
              notificationModelsToAdd.addAll({model.intId: model});
            }
          }
        }

        //
        // Additional Content
        //

        /*
        |--------------------------------------------------------------------------
        | check for user follows
        |--------------------------------------------------------------------------
        */

        if (responseModel.additionalContent.containsKey(UserFollowTable.tableName)) {
          for (var followItem in (responseModel.additionalContent[UserFollowTable.tableName] as List)) {
            var followModel = UserFollowModel.fromJson(followItem);

            if (followModel.isModel) {
              userModelsToAdd[AppUtils.intVal(followModel.followedUserId)]
                  ?.setFollowedByCurrentUser(true, keepCache: true, isPending: followModel.isPending);
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for user blocks
        |--------------------------------------------------------------------------
        */

        if (responseModel.additionalContent.containsKey(UserBlockTable.tableName)) {
          for (var dataMap in (responseModel.additionalContent[UserBlockTable.tableName] as List)) {
            var model = UserBlockModel.fromJson(dataMap);

            if (model.isModel) {
              userModelsToAdd[AppUtils.intVal(model.blockedUserId)]?.setBlockedByCurrentUser(true);
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for hashtag follows
        |--------------------------------------------------------------------------
        */

        if (responseModel.additionalContent.containsKey(HashtagFollowTable.tableName)) {
          for (var dataMap in (responseModel.additionalContent[HashtagFollowTable.tableName] as List)) {
            var model = HashtagFollowModel.fromJson(dataMap);

            if (model.isModel) {
              hashtagModelsToAdd[AppUtils.intVal(model.followedHashtagId)]?.setFollowing(true);
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for post likes
        |--------------------------------------------------------------------------
        */

        if (responseModel.additionalContent.containsKey(PostLikeTable.tableName)) {
          for (var dataItem in (responseModel.additionalContent[PostLikeTable.tableName] as List)) {
            var model = PostLikeModel.fromJson(dataItem);

            if (model.isModel) {
              postModelsToAdd[AppUtils.intVal(model.likedPostId)]?.setLiked(true, keepCache: true);
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for post saves
        |--------------------------------------------------------------------------
        */

        if (responseModel.additionalContent.containsKey(PostSaveTable.tableName)) {
          for (var dataMap in (responseModel.additionalContent[PostSaveTable.tableName] as List)) {
            var model = PostSaveModel.fromJson(dataMap);

            if (model.isModel) {
              postModelsToAdd[AppUtils.intVal(model.savedPostId)]?.saveToCollectionId(model.savedToCollectionId);
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | check for post comment likes
        |--------------------------------------------------------------------------
        */

        if (responseModel.additionalContent.containsKey(PostCommentLikeTable.tableName)) {
          for (var dataMap in (responseModel.additionalContent[PostCommentLikeTable.tableName] as List)) {
            var model = PostCommentLikeModel.fromJson(dataMap);

            if (model.isModel) {
              postCommentModelsToAdd[AppUtils.intVal(model.likedPostCommentId)]?.setLiked(true, keepCache: true);
            }
          }
        }

        /*
        |--------------------------------------------------------------------------
        | push new active content
        |--------------------------------------------------------------------------
        */

        ///
        /// ! helpful warning: if you're modifying source code
        ///
        /// whenever you add a new model type here, make sure  to add entires in garbage collector
        /// which exists entirely in its logical form, in the module [AppContentProvider]. not doing
        /// that directly lead to memory leaks. end user might not notice that but if a user happens
        /// to stay in app for long time and keeps on loading new content, then, over time, this gonna
        /// adds up and can eventually lead app to crash to prevent such memory leaks make sure that
        /// for each model type, there exists:
        ///
        /// 1. atleast one entry in [AppContentProvider._clearWidgetDependencies]
        /// 2. atleast one entry in [AppContentProvider._releaseResources]
        ///
        /// I wish I could automate this process for you but Dart doesn't support dynamic binding
        /// for type parameters, which means there's no way I can keep all types at one place and
        /// run a generic call for all model types.
        ///
        /// - erlage, Feb 8
        ///

        if (userModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<UserModel>(models: userModelsToAdd.values.toList());
        }

        if (postModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<PostModel>(models: postModelsToAdd.values.toList());
        }

        if (userFollowModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<UserFollowModel>(models: userFollowModelsToAdd.values.toList());
        }

        if (userBlockModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<UserBlockModel>(models: userBlockModelsToAdd.values.toList());
        }

        if (postLikeModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<PostLikeModel>(models: postLikeModelsToAdd.values.toList());
        }

        if (postCommentModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<PostCommentModel>(models: postCommentModelsToAdd.values.toList());
        }

        if (postSaveModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<PostSaveModel>(models: postSaveModelsToAdd.values.toList());
        }

        if (postCommentLikeModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<PostCommentLikeModel>(models: postCommentLikeModelsToAdd.values.toList());
        }

        if (postUserTagModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<PostUserTagModel>(models: postUserTagModelsToAdd.values.toList());
        }
        if (hashtagModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<HashtagModel>(models: hashtagModelsToAdd.values.toList());
        }

        if (hashtagPostModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<HashtagPostModel>(models: hashtagPostModelsToAdd.values.toList());
        }

        if (collectionModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<CollectionModel>(models: collectionModelsToAdd.values.toList());
        }

        if (notificationModelsToAdd.isNotEmpty) {
          addOrUpdateListOfModels<NotificationModel>(models: notificationModelsToAdd.values.toList());
        }
      }
    } catch (e) {
      AppLogger.exception(e);
    }
  }
}
