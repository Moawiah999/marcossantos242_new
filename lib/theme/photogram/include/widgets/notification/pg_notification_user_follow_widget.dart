import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgNotificationUserFollowWidget extends StatefulWidget {
  final int notificationId;

  const PgNotificationUserFollowWidget({
    Key? key,
    required this.notificationId,
  }) : super(key: key);

  @override
  State<PgNotificationUserFollowWidget> createState() => _PgNotificationUserFollowWidget();
}

class _PgNotificationUserFollowWidget extends State<PgNotificationUserFollowWidget>
    with AppActiveContentMixin, AppUserMixin, AppUtilsMixin {
  var _isValid = false;
  var _isAcceptedYourFollowRequest = false;

  late final NotificationModel _notificationModel;
  late final UserModel _byUserModel;

  @override
  void onLoadEvent() {
    _notificationModel = activeContent.read<NotificationModel>(widget.notificationId) ?? NotificationModel.none();

    // ensure notification data exists
    _isValid =
        _notificationModel.isModel && _notificationModel.linkedContent.collections.containsKey(UserTable.tableName);

    if (_isValid) {
      var byUserId = AppUtils.intVal(_notificationModel.linkedContent.collections[UserTable.tableName]!.first);

      _byUserModel = activeContent.read<UserModel>(byUserId) ?? UserModel.none();

      _isValid = _byUserModel.isModel;

      _isAcceptedYourFollowRequest = _notificationModel.metaType == NotificationEnum.metaTypeUserFollowAccepted;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValid) {
      return AppLogger.fail('${_notificationModel.runtimeType}(${widget.notificationId})');
    }

    AppTile appTile = AppTile();

    appTile.onTap = () => PgUtils.openProfilePage(context, _byUserModel.intId, utilMixinSetState);

    appTile.leading = Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(_byUserModel.image),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        border: Border.all(
          color: _notificationModel.isRead ? ThemeBloc.colorScheme.background : ThemeBloc.colorScheme.primary,
          width: 2.0,
        ),
      ),
    );

    appTile.title = RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: _byUserModel.name,
            style: ThemeBloc.textInterface.boldBlackH5TextStyle(),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: _isAcceptedYourFollowRequest
                ? AppLocalizations.of(context)!.acceptedYourFollowRequest
                : AppLocalizations.of(context)!.startedFollowingYou,
            style: ThemeBloc.textInterface.normalBlackH5TextStyle(),
          ),
        ],
      ),
    );

    appTile.trailing = userMixinBuildRelationshipButton(userModel: _byUserModel);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: appTile.dispense(),
    );
  }
}
