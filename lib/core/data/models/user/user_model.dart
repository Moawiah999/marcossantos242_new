import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

///
/// protected fields/attributes are protected by server
/// they simply don't exists here in client implementation
/// e.g password attribute
///

class UserModel extends AbstractModel {
  @override
  int get intId => _intId;
  String get id => _stringId;

  // primary key

  late final int _intId;
  late final String _stringId;

  // creds

  late String _email;
  late String _username;

  // display

  late String _displayName;
  late String _displayBio;
  late String _displayWeb;
  late UserDisplayImageDTO _displayImage;

  // meta

  late String _metaAccess;
  late String _metaIsPrivate;
  late String _metaLastActive;
  late UserMetaPushSettingsDTO _metaPushSettings;

  // cache

  late int _cachePostsCount;
  late int _cacheFollowersCount;
  late int _cacheFollowingsCount;

  // stamp

  late String _stampRegistration;

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  String get email => _email;
  String get username => _username;

  // display

  String get displayName => _displayName;
  String get displayBio => _displayBio;
  String get displayWeb => _displayWeb;
  UserDisplayImageDTO get displayImage => _displayImage;

  /// return [displayName] property if not empty, else returns [username]
  String get name => (displayName.isEmpty) ? username : displayName;

  /// return [displayImage] property
  String get image => displayImage.urlCompressed;

  // meta

  String get metaAccess => _metaAccess;
  String get metaIsPrivate => _metaIsPrivate;
  String get metaLastActive => _metaLastActive;
  UserMetaPushSettingsDTO get metaPushSettings => _metaPushSettings;

  int get cachePostsCount => _cachePostsCount;
  int get cacheFollowersCount => _cacheFollowersCount;
  int get cacheFollowingsCount => _cacheFollowingsCount;

  // stamp

  String get stampRegistration => _stampRegistration;

  // helper getters

  bool get isLoggedIn => _metaAccess.isNotEmpty;

  /*
  |--------------------------------------------------------------------------
  | account privacy related, client added fields
  |--------------------------------------------------------------------------
  */

  var isPrivateAccount = false;

  var isFollowRequestPending = false;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  UserModel();

  factory UserModel.none() => UserModel();

  /*
  |--------------------------------------------------------------------------
  | from json:
  |--------------------------------------------------------------------------
  */

  UserModel.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      // primary key

      _intId = AppUtils.intVal(jsonMap[UserTable.id]);

      _stringId = jsonMap[UserTable.id];

      // creds

      _email = jsonMap[UserTable.email] ?? ''; // private
      _username = jsonMap[UserTable.username];

      // display

      _displayName = jsonMap[UserTable.displayName];
      _displayBio = jsonMap[UserTable.displayBio];

      // display image
      var displayImageDTO = UserDisplayImageDTO.fromJson(jsonMap[UserTable.displayImage]);
      if (displayImageDTO.isNotDTO) {
        throw Exception();
      }

      _displayImage = displayImageDTO;

      _displayWeb = jsonMap[UserTable.displayWeb];

      // meta

      _metaAccess = jsonMap[UserTable.metaAccess] ?? ''; // private
      _metaLastActive = jsonMap[UserTable.metaLastActive];
      _metaIsPrivate = jsonMap[UserTable.metaIsPrivate];

      if (jsonMap.containsKey(UserTable.metaPushSettings)) {
        var metaPushSettingsDTO =
            UserMetaPushSettingsDTO.fromJson(jsonMap[UserTable.metaPushSettings]); // private
        _metaPushSettings = metaPushSettingsDTO;
      } else {
        _metaPushSettings = UserMetaPushSettingsDTO.none();
      }

      // cache

      _cachePostsCount = AppUtils.intVal(jsonMap[UserTable.cachePostsCount]);
      _cacheFollowersCount = AppUtils.intVal(jsonMap[UserTable.cacheFollowersCount]);
      _cacheFollowingsCount = AppUtils.intVal(jsonMap[UserTable.cacheFollowingsCount]);

      // stamps

      _stampRegistration = jsonMap[UserTable.stampRegistration] ?? ''; // private

      // update internal state(if any)

      setAccountPrivacy(metaIsPrivate);

      // done, model is now a valid object

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
        UserTable.id: id,

        // creds

        UserTable.email: email,
        UserTable.username: username,

        // public

        UserTable.displayName: displayName,
        UserTable.displayBio: displayBio,
        UserTable.displayImage: displayImage.toJson(),
        UserTable.displayWeb: displayWeb,

        // meta

        UserTable.metaAccess: metaAccess,
        UserTable.metaIsPrivate: metaIsPrivate,
        UserTable.metaLastActive: metaLastActive,
        UserTable.metaPushSettings: metaPushSettings.toJson(),

        // cache

        UserTable.cachePostsCount: cachePostsCount,
        UserTable.cacheFollowersCount: cacheFollowersCount,
        UserTable.cacheFollowingsCount: cacheFollowingsCount,

        // stamp

        UserTable.stampRegistration: stampRegistration,
      };

  @override
  void mergeChanges(dynamic receivedModel) {
    receivedModel as UserModel;

    // creds

    _email = receivedModel.email;
    _username = receivedModel.username;

    _displayName = receivedModel.displayName;
    _displayBio = receivedModel.displayBio;
    _displayImage = receivedModel.displayImage;
    _displayWeb = receivedModel.displayWeb;

    // meta

    _metaAccess = receivedModel.metaAccess;
    _metaIsPrivate = receivedModel.metaIsPrivate;
    _metaLastActive = receivedModel.metaLastActive;
    _metaPushSettings = receivedModel.metaPushSettings;

    // cache

    _cachePostsCount = receivedModel.cachePostsCount;
    _cacheFollowersCount = receivedModel.cacheFollowersCount;
    _cacheFollowingsCount = receivedModel.cacheFollowingsCount;

    // stamps

    _stampRegistration = receivedModel.stampRegistration;

    // gracefully handle model state updates

    if (!_isFollowedByCurrentUser && receivedModel.isFollowedByCurrentUser) {
      _isFollowedByCurrentUser = true;
    }

    if (!_isBlockedByCurrentUser && receivedModel.isBlockedByCurrentUser) {
      _isBlockedByCurrentUser = true;
    }

    if (!isPrivateAccount && UserEnum.metaIsPrivateYes == receivedModel.metaIsPrivate) {
      setAccountPrivacy(receivedModel.metaIsPrivate);
    }

    isFollowRequestPending = receivedModel.isFollowRequestPending;
  }

  /*
  |--------------------------------------------------------------------------
  | client specific implementations
  |--------------------------------------------------------------------------
  */

  void setAccountPrivacy(String toSet) {
    isPrivateAccount = (UserEnum.metaIsPrivateYes == toSet);
  }

  void unsetAccountPrivacy(String previouslySet) {
    isPrivateAccount = !(UserEnum.metaIsPrivateYes == previouslySet);
  }

  void setPendingStatus(String toSet) {
    isFollowRequestPending = (UserEnum.metaIsPrivateYes == toSet);
  }

  /*
  |--------------------------------------------------------------------------
  | follow related
  |--------------------------------------------------------------------------
  */

  var _isFollowedByCurrentUser = false;
  bool get isFollowedByCurrentUser => _isFollowedByCurrentUser;

  void setFollowedByCurrentUser(
    bool setTo, {
    bool isPending = false,
    bool keepCache = false,
  }) {
    if (keepCache) {
      _isFollowedByCurrentUser = setTo;
      isFollowRequestPending = isPending;
      return;
    }

    // un-follow
    if (!setTo && _isFollowedByCurrentUser) {
      // if private account just unset pending request
      if (isPrivateAccount) {
        isFollowRequestPending = false;

        // else update follower count
      } else {
        var totalFollowers = cacheFollowersCount - 1;

        if (totalFollowers > -1) {
          _cacheFollowersCount = totalFollowers;
        }
      }
    }

    // follow
    if (setTo && !_isFollowedByCurrentUser) {
      // if private account, set follow request to pending
      if (isPrivateAccount) {
        isFollowRequestPending = true;

        // else update follower count
      } else {
        var totalFollowers = cacheFollowersCount + 1;

        if (totalFollowers > -1) {
          _cacheFollowersCount = totalFollowers;
        }
      }
    }

    _isFollowedByCurrentUser = setTo;
  }

  /*
  |--------------------------------------------------------------------------
  | blocking related
  |--------------------------------------------------------------------------
  */

  var _isBlockedByCurrentUser = false;
  bool get isBlockedByCurrentUser => _isBlockedByCurrentUser;

  void setBlockedByCurrentUser(bool setTo) {
    _isBlockedByCurrentUser = setTo;

    // unfollow user,
    //
    // 1. if a block user request, no explanation needed
    //
    // 2. if a unblock request, target user was unfollowed before being blocked in the system
    //
    // therefore always unfollow user on a block request
    setFollowedByCurrentUser(false);
  }
}
