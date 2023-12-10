import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class PostModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // ids

  late String _ownerUserId;

  // display

  late String _displayCaption;
  late String _displayLocation;
  late PostDisplayContentDTO _displayContent;

  // meta

  late Map<String, int> _metaHashtags;

  // cache

  late int _cacheLikesCount;
  late int _cacheCommentsCount;

  // stamp

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

  String get displayCaption => _displayCaption;
  String get displayLocation => _displayLocation;
  PostDisplayContentDTO get displayContent => _displayContent;

  /// return first image from post
  String get getFirstImageUrlFromPostContent => displayContent.firstImageUrl;

  // meta

  Map<String, int> get metaHashtags => _metaHashtags;

  // cache

  int get cacheLikesCount => _cacheLikesCount;
  int get cacheCommentsCount => _cacheCommentsCount;

  // stamp

  String get stampRegistration => _stampRegistration;
  String get stampLastUpdate => _stampLastUpdate;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  PostModel();

  factory PostModel.none() => PostModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  PostModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary

      _intId = AppUtils.intVal(jsonMap[PostTable.id]);
      _stringId = jsonMap[PostTable.id];

      // ids

      _ownerUserId = jsonMap[PostTable.ownerUserId];

      // display

      _displayCaption = jsonMap[PostTable.displayCaption];
      _displayLocation = jsonMap[PostTable.displayLocation];

      _displayContent = PostDisplayContentDTO.fromJsonList(jsonMap[PostTable.displayContent]);

      // if fails to parse display content
      if (displayContent.isNotDTO) {
        throw Exception();
      }

      // meta

      _metaHashtags = <String, int>{};

      if (jsonMap[PostTable.metaHashtags] is Map) {
        (jsonMap[PostTable.metaHashtags] as Map<String, dynamic>).forEach((hashtag, id) {
          metaHashtags[hashtag] = AppUtils.intVal(id);
        });
      }

      // cache

      _cacheLikesCount = AppUtils.intVal(jsonMap[PostTable.cacheLikesCount]);
      _cacheCommentsCount = AppUtils.intVal(jsonMap[PostTable.cacheCommentsCount]);

      // stamps

      _stampRegistration = jsonMap[PostTable.stampRegistration];
      _stampLastUpdate = jsonMap[PostTable.stampLastUpdate];

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
        // ids

        PostTable.id: id,
        PostTable.ownerUserId: ownerUserId,

        // public

        PostTable.displayCaption: displayCaption,
        PostTable.displayLocation: displayLocation,
        PostTable.displayContent: displayContent.toJson(),

        // meta

        PostTable.metaHashtags: metaHashtags,

        // cache

        PostTable.cacheLikesCount: cacheLikesCount,
        PostTable.cacheCommentsCount: cacheCommentsCount,

        // stamp

        PostTable.stampRegistration: stampRegistration,
        PostTable.stampLastUpdate: stampLastUpdate,
      };

  /*
  |--------------------------------------------------------------------------
  | merger
  |--------------------------------------------------------------------------
  */

  @override
  void mergeChanges(receivedModel) {
    receivedModel as PostModel;

    // ids

    _ownerUserId = receivedModel.ownerUserId;

    // display

    _displayCaption = receivedModel.displayCaption;
    _displayLocation = receivedModel.displayLocation;
    _displayContent = receivedModel.displayContent;

    // meta

    _metaHashtags = receivedModel.metaHashtags;

    // cache

    _cacheLikesCount = receivedModel.cacheLikesCount;
    _cacheCommentsCount = receivedModel.cacheCommentsCount;

    // stamps

    _stampRegistration = receivedModel.stampRegistration;
    _stampLastUpdate = receivedModel.stampLastUpdate;

    // gracefully handle model state updates

    if (!_liked && receivedModel.isLiked) {
      _liked = true;
    }

    if (receivedModel.isSaved) {
      receivedModel.savedToCollectionIds.forEach(saveToCollectionId);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | client specific implementations
  |--------------------------------------------------------------------------
  */

  /*
  |--------------------------------------------------------------------------
  | like
  |--------------------------------------------------------------------------
  */

  var _liked = false;

  bool get isLiked => _liked;
  bool get isNotLiked => !_liked;

  bool setLiked(bool setTo, {bool keepCache = false}) {
    if (keepCache) {
      _liked = setTo;
      return setTo;
    }

    // unlike
    if (!setTo && isLiked) {
      var totalLikes = cacheLikesCount - 1;

      if (totalLikes > -1) {
        _cacheLikesCount = totalLikes;
      }
    }

    // like
    if (setTo && isNotLiked) {
      var totalLikes = cacheLikesCount + 1;

      if (totalLikes > -1) {
        _cacheLikesCount = totalLikes;
      }
    }

    _liked = setTo;

    return setTo;
  }

  /*
  |--------------------------------------------------------------------------
  | save
  |--------------------------------------------------------------------------
  */

  final _savedToCollectionIds = <String>{};

  bool get isSaved => _savedToCollectionIds.isNotEmpty;
  bool get isNotSaved => _savedToCollectionIds.isEmpty;
  Set<String> get savedToCollectionIds => _savedToCollectionIds;

  bool isSavedInCollection(String collectionId) => _savedToCollectionIds.contains(collectionId);
  bool saveToCollectionId(String collectionId) => _savedToCollectionIds.add(collectionId);
  bool removeFromCollectionId(String collectionId) => _savedToCollectionIds.remove(collectionId);

  void clearSavedToCollectionIds(String collectionId) => _savedToCollectionIds.clear();
  void removeFromAllCollections() => _savedToCollectionIds.clear();
}
