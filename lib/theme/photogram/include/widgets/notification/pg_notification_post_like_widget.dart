import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgNotificationPostLikeWidget extends StatefulWidget {
  final int notificationId;

  const PgNotificationPostLikeWidget({
    Key? key,
    required this.notificationId,
  }) : super(key: key);

  @override
  State<PgNotificationPostLikeWidget> createState() => _PgNotificationPostLikeWidgetState();
}

class _PgNotificationPostLikeWidgetState extends State<PgNotificationPostLikeWidget>
    with AppActiveContentMixin, AppUtilsMixin {
  var _isValid = false;
  var _onPhotoOfYou = false;

  late final NotificationModel _notificationModel;
  late final PostModel _targetPostModel;
  late final _userModels = <UserModel>[];

  @override
  void onLoadEvent() {
    _notificationModel = activeContent.read<NotificationModel>(widget.notificationId) ?? NotificationModel.none();

    // ensure notification data exists
    _isValid = _notificationModel.isModel &&
        _notificationModel.linkedContent.collections.containsKey(UserTable.tableName) &&
        _notificationModel.linkedContent.collections.containsKey(PostTable.tableName);

    // ensure target post exists
    if (_isValid) {
      var targetPostId = AppUtils.intVal(_notificationModel.linkedContent.collections[PostTable.tableName]!.first);
      _targetPostModel = activeContent.read<PostModel>(targetPostId) ?? PostModel.none();
      _isValid = _targetPostModel.isModel;
    }

    // if everything is okay, read user models
    if (_isValid) {
      for (var id in _notificationModel.linkedContent.collections[UserTable.tableName]!.reversed) {
        var userModel = activeContent.read<UserModel>(AppUtils.intVal(id)) ?? UserModel.none();

        if (userModel.isModel && _userModels.length < 2) {
          _userModels.add(userModel);
        }
      }
    }

    _onPhotoOfYou = _notificationModel.metaType == NotificationEnum.metaTypePostLikeonPhotoOfYou;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValid) {
      return AppLogger.fail('${_notificationModel.runtimeType}(${widget.notificationId})');
    }

    return ListTile(
      minVerticalPadding: 18,
      leading: _buildLeading(),
      title: _buildTitle(),
      trailing: _buildTrailing(),
    );
  }

  Widget _buildLeading() {
    if (_userModels.length > 1) {
      return SizedBox(
        width: 50,
        height: 50,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => PgUtils.openProfilePage(context, _userModels[0].intId, utilMixinSetState),
                child: CachedNetworkImage(
                  imageUrl: _userModels[0].image,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          color: _notificationModel.isRead
                              ? ThemeBloc.colorScheme.background
                              : ThemeBloc.colorScheme.primary,
                          width: 2.0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () => PgUtils.openProfilePage(context, _userModels[1].intId, utilMixinSetState),
                child: CachedNetworkImage(
                  imageUrl: _userModels[1].image,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          color: _notificationModel.isRead
                              ? ThemeBloc.colorScheme.background
                              : ThemeBloc.colorScheme.primary,
                          width: 2.0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => PgUtils.openProfilePage(context, _userModels.first.intId, utilMixinSetState),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(_userModels.first.image),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          border: Border.all(
            color: _notificationModel.isRead ? ThemeBloc.colorScheme.background : ThemeBloc.colorScheme.primary,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    var textSpans = <TextSpan>[];

    if (_userModels.length > 1) {
      textSpans.add(
        TextSpan(
          text: _userModels[1].name + ', ',
          style: ThemeBloc.textInterface.boldBlackH5TextStyle(),
          recognizer: TapGestureRecognizer()
            ..onTap = () => PgUtils.openProfilePage(context, _userModels[1].intId, utilMixinSetState),
        ),
      );
    }

    textSpans.add(
      TextSpan(
        text: _userModels[0].name,
        style: ThemeBloc.textInterface.boldBlackH5TextStyle(),
        recognizer: TapGestureRecognizer()
          ..onTap = () => PgUtils.openProfilePage(context, _userModels[0].intId, utilMixinSetState),
      ),
    );

    textSpans.add(
      TextSpan(
        text: _targetPostModel.cacheLikesCount > 2
            ? sprintf(
                _onPhotoOfYou
                    ? AppLocalizations.of(context)!.andNOthersLikedPhotoOfYou
                    : AppLocalizations.of(context)!.andNOthersLikedYourPost,
                [
                  _targetPostModel.cacheLikesCount - _userModels.length,
                ],
              )
            : _onPhotoOfYou
                ? AppLocalizations.of(context)!.likedPhotoOfYou
                : AppLocalizations.of(context)!.likedYourPost,
        style: ThemeBloc.textInterface.normalBlackH5TextStyle(),
      ),
    );

    return RichText(text: TextSpan(children: textSpans));
  }

  Widget _buildTrailing() {
    return GestureDetector(
      onTap: () => PgUtils.openPostPage(context, _targetPostModel.intId, utilMixinSetState),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          imageUrl: _targetPostModel.getFirstImageUrlFromPostContent,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
