import 'dart:math';

import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/notification/pg_follow_requests_widget.dart';
import 'package:photogram/theme/photogram/include/widgets/notification/pg_notification_photo_of_you_widget.dart';
import 'package:photogram/theme/photogram/include/widgets/notification/pg_notification_post_comment_like_widget.dart';
import 'package:photogram/theme/photogram/include/widgets/notification/pg_notification_post_comment_reply_widget.dart';
import 'package:photogram/theme/photogram/include/widgets/notification/pg_notification_post_comment_widget.dart';
import 'package:photogram/theme/photogram/include/widgets/notification/pg_notification_post_like_widget.dart';
import 'package:photogram/theme/photogram/include/widgets/notification/pg_notification_user_follow_widget.dart';

class PgActivityPage extends ActivityPage {
  const PgActivityPage({Key? key}) : super(key: key);

  @override
  _PgActivityPageState createState() => _PgActivityPageState();
}

class _PgActivityPageState extends State<PgActivityPage>
    with AppActiveContentInfiniteMixin, AppUserMixin, AppUtilsMixin {
  final _notificationIds = <int>[];
  var _followRequestsStateInstanceId = PgUtils.random();

  @override
  void onLoadEvent() {
    _loadNotifications(latest: true);
  }

  @override
  onReloadBeforeEvent() {
    _followRequestsStateInstanceId = PgUtils.random();
    _notificationIds.clear();
    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadNotifications(latest: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.activity)),
      body: RefreshIndicator(
        onRefresh: contentMixinReloadPage,
        child: Column(
          children: [
            if (isLoadingLatest)
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(5),
                color: ThemeBloc.colorScheme.background,
                child: PgUtils.darkCupertinoActivityIndicator(),
              ),
            if (activeContent.authBloc.getCurrentUser.isPrivateAccount)
              PgFollowRequestsWidget(
                instanceStateId: _followRequestsStateInstanceId,
              ),
            Expanded(
              child: _notificationIds.isEmpty && !isLoadingCallInStack
                  ? _buildInfoSection()
                  : ListView.builder(
                      itemCount: isLoadingBottom ? _notificationIds.length + 1 : _notificationIds.length,
                      itemBuilder: (context, index) => _buildNotification(index),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotification(int index) {
    /*
    |--------------------------------------------------------------------------
    | aggressive prefetching
    |--------------------------------------------------------------------------
    */

    if (_notificationIds.length - 3 < index) {
      _loadNotifications(waitForFrame: true);
    }

    /*
    |--------------------------------------------------------------------------
    | check if there are widgets to build:
    |--------------------------------------------------------------------------
    */

    if (_notificationIds.length > index) {
      var notificationModel =
          activeContent.read<NotificationModel>(_notificationIds[index]) ?? NotificationModel.none();

      if (notificationModel.isModel) {
        return _buildNotificationWidget(notificationModel);
      }

      return AppUtils.nothing();
    }

    return PgUtils.darkCupertinoActivityIndicator();
  }

  Widget _buildInfoSection() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(32),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Column(
              children: [
                const Icon(Icons.notifications_outlined),
                PgUtils.sizedBoxH(10),
                Text(
                  AppLocalizations.of(context)!.notifications,
                  style: ThemeBloc.textInterface.boldBlackH2TextStyle(),
                  textAlign: TextAlign.center,
                ),
                PgUtils.sizedBoxH(10),
                Text(
                  AppLocalizations.of(context)!.activityWillAppearHere,
                  style: ThemeBloc.textInterface.normalGreyH5TextStyle(),
                  textAlign: TextAlign.center,
                ),
                PgUtils.sizedBoxH(20),
                ThemeBloc.widgetInterface.divider(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationWidget(NotificationModel notificationModel) {
    switch (notificationModel.metaType) {
      case NotificationEnum.metaTypePostLike:
      case NotificationEnum.metaTypePostLikeonPhotoOfYou:
        return PgNotificationPostLikeWidget(notificationId: notificationModel.intId);

      case NotificationEnum.metaTypePostComment:
      case NotificationEnum.metaTypePostCommentOnPhotoOfYou:
        return PgNotificationPostCommentWidget(notificationId: notificationModel.intId);

      case NotificationEnum.metaTypePostCommentLike:
        return PgNotificationPostCommentLikeWidget(notificationId: notificationModel.intId);

      case NotificationEnum.metaTypePostCommentReply:
        return PgNotificationPostCommentReplyWidget(notificationId: notificationModel.intId);

      case NotificationEnum.metaTypePhotoOfYou:
        return PgNotificationPhotoOfYouWidget(notificationId: notificationModel.intId);

      case NotificationEnum.metaTypeUserFollow:
      case NotificationEnum.metaTypeUserFollowAccepted:
        return PgNotificationUserFollowWidget(notificationId: notificationModel.intId);
    }

    return AppUtils.nothing();
  }

  Future<void> _loadNotifications({bool latest = false, bool waitForFrame = false}) async {
    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_NOTIFICATION_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_NOTIFICATION_LOAD_BOTTOM,
      requestDataGenerator: () => {
        RequestTable.offset: {
          NotifcationTable.tableName: {NotifcationTable.id: latest ? latestContentId : bottomContentId},
        },
      },
    );
  }

  handleResponse({
    bool latest = false,
    required ResponseModel responseModel,
  }) {
    activeContent.handleResponse(responseModel);

    utilMixinSetState(() {
      activeContent.pagedModels<NotificationModel>().forEach((notificationId, notificationModel) {
        if (!_notificationIds.contains(notificationId)) {
          _notificationIds.add(notificationId);
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _notificationIds.isEmpty ? 0 : _notificationIds.reduce(max),
        setBottomContentId: _notificationIds.isEmpty ? 0 : _notificationIds.reduce(min),
      );
    });
  }
}
