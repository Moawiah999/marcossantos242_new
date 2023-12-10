import 'package:photogram/import/core.dart';

class UserMetaPushSettingsDTO {
  var _isDTO = false;

  /*
  |--------------------------------------------------------------------------
  | data
  |--------------------------------------------------------------------------
  */

  late String pauseAll;
  late String likes;
  late String comments;
  late String photosOfYou;
  late String likesOnPhotosOfYou;
  late String commentsOnPhotosOfYou;
  late String commentLikesAndPins;
  late String acceptedFollowRequest;

  /*
  |--------------------------------------------------------------------------
  | getters
  |--------------------------------------------------------------------------
  */

  bool get isDTO => _isDTO;
  bool get isNotDTO => !_isDTO;

  /*
  |--------------------------------------------------------------------------
  | factory:
  |--------------------------------------------------------------------------
  */

  UserMetaPushSettingsDTO();

  factory UserMetaPushSettingsDTO.none() => UserMetaPushSettingsDTO();

  /*
  |--------------------------------------------------------------------------
  | from data
  |--------------------------------------------------------------------------
  */

  UserMetaPushSettingsDTO.fromData({
    required this.pauseAll,
    required this.likes,
    required this.comments,
    required this.photosOfYou,
    required this.likesOnPhotosOfYou,
    required this.commentsOnPhotosOfYou,
    required this.commentLikesAndPins,
    required this.acceptedFollowRequest,
  }) {
    _isDTO = true;
  }

  /*
  |--------------------------------------------------------------------------
  | from json
  |--------------------------------------------------------------------------
  */

  UserMetaPushSettingsDTO.fromJson(Map<String, dynamic> jsonMap) {
    /*
    |--------------------------------------------------------------------------
    | try setting all fields:
    |--------------------------------------------------------------------------
    */
    try {
      pauseAll = jsonMap[keyPauseAll];
      likes = jsonMap[keyLikes];
      comments = jsonMap[keyComments];
      photosOfYou = jsonMap[keyPhotosOfYou];
      likesOnPhotosOfYou = jsonMap[keyLikesOnPhotosOfYou];
      commentsOnPhotosOfYou = jsonMap[keyCommentsOnPhotosOfYou];
      commentLikesAndPins = jsonMap[keyCommentLikesAndPins];
      acceptedFollowRequest = jsonMap[keyAcceptedFollowRequest];

      _isDTO = true;
    } catch (e) {
      AppLogger.info(e, logType: AppLogType.parser);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | to json
  |--------------------------------------------------------------------------
  */

  Map<String, dynamic> toJson() => {
        keyPauseAll: pauseAll,
        keyLikes: likes,
        keyComments: comments,
        keyPhotosOfYou: photosOfYou,
        keyLikesOnPhotosOfYou: likesOnPhotosOfYou,
        keyCommentsOnPhotosOfYou: commentsOnPhotosOfYou,
        keyCommentLikesAndPins: commentLikesAndPins,
        keyAcceptedFollowRequest: acceptedFollowRequest,
      };

  /*
  |--------------------------------------------------------------------------
  | key maps, must not change
  |--------------------------------------------------------------------------
  */

  // master setting, to disable all

  static const keyPauseAll = 'pause_all';

  // likes on posts of user

  static const keyLikes = 'likes';

  // comments on posts of user

  static const keyComments = 'comments';

  // someone tagged you in their photo

  static const keyPhotosOfYou = 'photos_of_you';

  // likes on posts in which user is tagged

  static const keyLikesOnPhotosOfYou = 'likes_on_photos_of_you';

  // comments on posts in which user is tagged

  static const keyCommentsOnPhotosOfYou = 'comments_on_photos_of_you';

  // likes on comments by user

  static const keyCommentLikesAndPins = 'comment_likes_and_pins';

  // notify when someone accepted your follow request

  static const keyAcceptedFollowRequest = 'accepted_follow_request';

  /*
  |--------------------------------------------------------------------------
  | value types
  |--------------------------------------------------------------------------
  */

  static const valueNotAvailable = 'not_available';

  static const valueOn = 'on';

  static const valueOff = 'off';

  static const valueFromEveryone = 'from_everyone';

  static const valueFromPeopleIFollow = 'from_people_i_follow';
}
