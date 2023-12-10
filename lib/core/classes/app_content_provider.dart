import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class AppContentProvider {
  /*
  |--------------------------------------------------------------------------
  | shared model storage
  |--------------------------------------------------------------------------
  */

  late final _sharedModelStorage = <String, Map<int, dynamic>>{};

  /*
  |--------------------------------------------------------------------------
  | dependency graphs
  |--------------------------------------------------------------------------
  */

  late final _widgetToModelDependencies = DependencyGraph<String, int>('WidgetToModelDependencies');

  late final _modelToWidgetDependencies = DependencyGraph<int, String>('ModelToWidgetDependencies');

  /*
  |--------------------------------------------------------------------------
  | constructor
  |--------------------------------------------------------------------------
  */

  AppContentProvider() {
    AppLogger.info("AppContentProvider: Init", logType: AppLogType.appContentProvider);
  }

  /*
  |--------------------------------------------------------------------------
  | dispose
  |--------------------------------------------------------------------------
  */

  void dispose() {
    _sharedModelStorage.clear();
    _modelToWidgetDependencies.clear();
    _widgetToModelDependencies.clear();
  }

  /*
  |--------------------------------------------------------------------------
  | content
  |--------------------------------------------------------------------------
  */

  Map<int, T> _allModels<T>() {
    if (!_sharedModelStorage.containsKey(T.toString())) return {};

    return _sharedModelStorage[T.toString()]! as Map<int, T>;
  }

  Map<int, T> pagedModels<T>({required String widgetInstanceId}) {
    var map = <int, T>{};

    var ids = _widgetToModelDependencies.list<T>(startPoint: widgetInstanceId)..sort();

    for (var contentId in ids.reversed) {
      map.addAll({contentId: _allModels<T>()[contentId] as T});
    }

    return map;
  }

  T? watch<T>({
    required String widgetInstanceId,
    required int contentId,
  }) {
    var model = _allModels<T>()[contentId];

    if (null == model) return null;

    model as AbstractModel;

    _widgetToModelDependencies.add<T>(startPoint: widgetInstanceId, endPoint: model.intId);
    _modelToWidgetDependencies.add<T>(startPoint: model.intId, endPoint: widgetInstanceId);

    return model;
  }

  T? read<T>({
    required String widgetInstanceId,
    required int contentId,
  }) =>
      _allModels<T>()[contentId];

  void unlink<T>({
    required String widgetInstanceId,
    required int contentId,
  }) {
    _widgetToModelDependencies.remove<T>(startPoint: widgetInstanceId, endPoint: contentId);
    _modelToWidgetDependencies.remove<T>(startPoint: contentId, endPoint: widgetInstanceId);
  }

  /*
  |--------------------------------------------------------------------------
  | add content
  |--------------------------------------------------------------------------
  */

  List<int> addOrUpdateAll<T>({
    List<T> models = const [],
    required String widgetInstanceId,
  }) {
    var contentIdsAdded = <int>[];

    for (T model in models) {
      contentIdsAdded.add(
        addOrUpdateModel<T>(
          model: model,
          widgetInstanceId: widgetInstanceId,
        ),
      );
    }

    return contentIdsAdded;
  }

  int addOrUpdateModel<T>({
    required T model,
    required String widgetInstanceId,
  }) {
    var idToReturn = 0;

    if (null != model) {
      model as AbstractModel;

      // make sure namespace for type exists
      if (!_sharedModelStorage.containsKey(T.toString())) {
        _sharedModelStorage.addAll({T.toString(): <int, T>{}});

        AppLogger.info("AppContentProvider: Create Storage Namespace: ${T.toString()}",
            logType: AppLogType.appContentProvider);
      }

      (_sharedModelStorage[T.toString()] as Map<int, T>).update(
        model.intId,

        // update
        (existingModel) {
          existingModel as AbstractModel;

          existingModel.mergeChanges(model);

          idToReturn = existingModel.intId;

          return existingModel;
        },

        // insert
        ifAbsent: () => model,
      );

      AppLogger.info("AppContentProvider: Update ${T.toString()}:ID(${model.intId})",
          logType: AppLogType.appContentProvider);

      // add dependencies
      _widgetToModelDependencies.add<T>(startPoint: widgetInstanceId, endPoint: model.intId);
      _modelToWidgetDependencies.add<T>(startPoint: model.intId, endPoint: widgetInstanceId);
    }

    return idToReturn;
  }

  Set<String> listWidgetInstances<T>({required List<int> contentIds}) {
    var instancesToUpdate = <String>{};

    for (var contentId in contentIds) {
      if (contentId == 0) continue;

      instancesToUpdate.addAll(_modelToWidgetDependencies.list<T>(startPoint: contentId));
    }

    return instancesToUpdate;
  }

  /*
  |--------------------------------------------------------------------------
  | can be called on page reload
  |--------------------------------------------------------------------------
  */

  void clearWidget({required String disposedWidgetInstanceId}) {
    _clearWidgetDependencies(widgetInstanceId: disposedWidgetInstanceId);
  }

  /*
  |--------------------------------------------------------------------------
  | will be called when widget got disposed from the tree
  |--------------------------------------------------------------------------
  */

  void disposeWidget({required String disposedWidgetInstanceId}) {
    _clearWidgetDependencies(widgetInstanceId: disposedWidgetInstanceId);
    _releaseResources();
  }

  /*
  |--------------------------------------------------------------------------
  | clear widget dependencies
  |--------------------------------------------------------------------------
  */

  void _clearWidgetDependencies({required String widgetInstanceId}) {
    AppLogger.info("AppContentProvider: Clear Widget Dependencies: $widgetInstanceId",
        logType: AppLogType.appContentProvider);

    clearDependencies<UserModel>(widgetInstanceId: widgetInstanceId);

    clearDependencies<UserFollowModel>(widgetInstanceId: widgetInstanceId);
    clearDependencies<UserBlockModel>(widgetInstanceId: widgetInstanceId);

    clearDependencies<PostModel>(widgetInstanceId: widgetInstanceId);

    clearDependencies<PostLikeModel>(widgetInstanceId: widgetInstanceId);
    clearDependencies<PostSaveModel>(widgetInstanceId: widgetInstanceId);
    clearDependencies<PostCommentModel>(widgetInstanceId: widgetInstanceId);
    clearDependencies<PostCommentLikeModel>(widgetInstanceId: widgetInstanceId);
    clearDependencies<PostUserTagModel>(widgetInstanceId: widgetInstanceId);

    clearDependencies<HashtagModel>(widgetInstanceId: widgetInstanceId);
    clearDependencies<HashtagPostModel>(widgetInstanceId: widgetInstanceId);
    clearDependencies<HashtagFollowModel>(widgetInstanceId: widgetInstanceId);

    clearDependencies<CollectionModel>(widgetInstanceId: widgetInstanceId);

    clearDependencies<NotificationModel>(widgetInstanceId: widgetInstanceId);

    false;
  }

  void clearDependencies<T>({required String widgetInstanceId}) {
    var dependentContentIds = _widgetToModelDependencies.list<T>(startPoint: widgetInstanceId);

    var toIterate = [...dependentContentIds];

    for (var contentId in toIterate) {
      _widgetToModelDependencies.remove<T>(startPoint: widgetInstanceId, endPoint: contentId);
      _modelToWidgetDependencies.remove<T>(startPoint: contentId, endPoint: widgetInstanceId);
    }
  }

  void _releaseResources() {
    AppLogger.info("AppContentProvider: Release Resources", logType: AppLogType.appContentProvider);

    _releaseDependencies<UserModel>();

    _releaseDependencies<UserFollowModel>();
    _releaseDependencies<UserBlockModel>();

    _releaseDependencies<PostModel>();

    _releaseDependencies<PostLikeModel>();
    _releaseDependencies<PostSaveModel>();
    _releaseDependencies<PostCommentModel>();
    _releaseDependencies<PostCommentLikeModel>();
    _releaseDependencies<PostUserTagModel>();

    _releaseDependencies<HashtagModel>();
    _releaseDependencies<HashtagPostModel>();
    _releaseDependencies<HashtagFollowModel>();

    _releaseDependencies<CollectionModel>();

    _releaseDependencies<NotificationModel>();
  }

  void _releaseDependencies<T>() {
    var allModels = <int, T>{};

    allModels.addAll(_allModels<T>());

    allModels.forEach((key, value) {
      // list of pages that depends on content
      var dependentPageNames = _modelToWidgetDependencies.list<T>(startPoint: (value as AbstractModel).intId);

      // if none, remove the model
      if (dependentPageNames.isEmpty) {
        _sharedModelStorage[T.toString()]!.remove(key);

        AppLogger.info("AppContentProvider: Release resource ~> ${T.toString()} Key: $key",
            logType: AppLogType.appContentProvider);
      }
    });
  }
}
