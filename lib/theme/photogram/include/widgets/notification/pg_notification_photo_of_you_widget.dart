import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgNotificationPhotoOfYouWidget extends StatefulWidget {
  final int notificationId;

  const PgNotificationPhotoOfYouWidget({
    Key? key,
    required this.notificationId,
  }) : super(key: key);

  @override
  State<PgNotificationPhotoOfYouWidget> createState() => _PgNotificationPhotoOfYouWidgetState();
}

class _PgNotificationPhotoOfYouWidgetState extends State<PgNotificationPhotoOfYouWidget>
    with AppActiveContentMixin, AppUtilsMixin {
  var _isValid = false;

  late final NotificationModel _notificationModel;
  late final PostModel _targetPostModel;
  late final UserModel _byUserModel;

  @override
  void onLoadEvent() {
    _notificationModel = activeContent.read<NotificationModel>(widget.notificationId) ?? NotificationModel.none();

    // ensure notification data exists
    _isValid = _notificationModel.isModel &&
        _notificationModel.linkedContent.collections.containsKey(UserTable.tableName) &&
        _notificationModel.linkedContent.collections.containsKey(PostTable.tableName);

    if (_isValid) {
      var targetPostId = AppUtils.intVal(_notificationModel.linkedContent.collections[PostTable.tableName]!.first);
      var byUserId = AppUtils.intVal(_notificationModel.linkedContent.collections[UserTable.tableName]!.first);

      _targetPostModel = activeContent.read<PostModel>(targetPostId) ?? PostModel.none();
      _byUserModel = activeContent.read<UserModel>(byUserId) ?? UserModel.none();

      _isValid = _targetPostModel.isModel && _byUserModel.isModel;
    }
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
    return GestureDetector(
      onTap: () => PgUtils.openProfilePage(context, _byUserModel.intId, utilMixinSetState),
      child: Container(
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
      ),
    );
  }

  Widget _buildTitle() {
    var textSpans = <TextSpan>[];

    textSpans.add(
      TextSpan(
        text: _byUserModel.name,
        style: ThemeBloc.textInterface.boldBlackH5TextStyle(),
        recognizer: TapGestureRecognizer()
          ..onTap = () => PgUtils.openProfilePage(context, _byUserModel.intId, utilMixinSetState),
      ),
    );

    textSpans.add(
      TextSpan(
        text: AppLocalizations.of(context)!.taggedYouInAPhoto,
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
