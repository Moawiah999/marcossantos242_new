import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgFollowRequestsWidget extends StatefulWidget {
  final String instanceStateId;

  const PgFollowRequestsWidget({
    Key? key,
    required this.instanceStateId,
  }) : super(key: key);

  @override
  _PgFollowRequestsWidgetState createState() => _PgFollowRequestsWidgetState();
}

class _PgFollowRequestsWidgetState extends State<PgFollowRequestsWidget> with AppUtilsMixin {
  var _previousInstanceStateId = '';

  var _isInitialized = false;
  var _isVisible = true;
  var _isInitializingInProgress = false;

  late String _totalPendingCount;
  late UserModel _recentUserModel;

  void rebuildWidget() {
    var doReload = _previousInstanceStateId != widget.instanceStateId;

    if (doReload) {
      _isInitializingInProgress = false;
      _previousInstanceStateId = widget.instanceStateId;

      _refreshFollowRequestCounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    rebuildWidget();

    if (!_isVisible) {
      return AppUtils.nothing();
    }

    return Column(
      children: [
        PgUtils.sizedBoxH(10),
        _buildRequestsSection(),
        PgUtils.sizedBoxH(10),
        ThemeBloc.widgetInterface.divider(),
        PgUtils.sizedBoxH(10),
      ],
    );
  }

  Widget _buildRequestsSection() {
    if (!_isInitialized) {
      return ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: PgUtils.circularImageStationary(),
        ),
        title: ThemeBloc.textInterface.boldBlackH6Text(text: AppLocalizations.of(context)!.followRequests),
        subtitle: ThemeBloc.textInterface.normalGreyH6Text(text: AppLocalizations.of(context)!.approveOrIgnoreRequests),
      );
    }

    return ListTile(
      onTap: () => PgUtils.openPendingRequestsPage(context, utilMixinSetState),
      leading: SizedBox(
        width: 50,
        height: 50,
        child: Stack(
          children: [
            Positioned.fill(
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: CachedNetworkImageProvider(_recentUserModel.image),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Text(
                  _totalPendingCount.toString(),
                  style: ThemeBloc.textInterface.boldBlackH6TextStyle().copyWith(
                        color: ThemeBloc.colorScheme.onPrimary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
      title: ThemeBloc.textInterface.boldBlackH6Text(text: AppLocalizations.of(context)!.followRequests),
      subtitle: ThemeBloc.textInterface.normalGreyH6Text(text: AppLocalizations.of(context)!.approveOrIgnoreRequests),
    );
  }

  void _refreshFollowRequestCounts() async {
    if (_isInitializingInProgress) return;

    _isInitializingInProgress = true;

    var responseModel = await AppProvider.of(context).apiRepo.preparedRequest(
      requestType: REQ_TYPE_USER_FOLLOW_PENDING_COUNT_AND_RECENT,
      requestData: {},
    );

    if (SUCCESS_MSG == responseModel.message) {
      if (responseModel.contains(NotificationsCountDTO.dtoName)) {
        var notificationsCountDTO = NotificationsCountDTO.fromJson(responseModel.first(NotificationsCountDTO.dtoName));
        if (notificationsCountDTO.isDTO) {
          if (responseModel.contains(UserTable.tableName)) {
            _recentUserModel = UserModel.fromJson(responseModel.first(UserTable.tableName));
            if (_recentUserModel.isModel) {
              setState(() {
                _isInitializingInProgress = false;

                _isInitialized = true;
                _totalPendingCount = notificationsCountDTO.followCount;
              });

              return;
            }
          }
        }
      }
    }

    setState(() {
      _isInitializingInProgress = false;

      _isVisible = false;
    });
  }
}
