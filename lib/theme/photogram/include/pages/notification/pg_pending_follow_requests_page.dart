import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgPendingFollowRequestsPage extends PendingFollowRequestsPage {
  const PgPendingFollowRequestsPage({
    Key? key,
  }) : super(key: key);

  @override
  _PgPendingFollowRequestsPageState createState() => _PgPendingFollowRequestsPageState();
}

class _PgPendingFollowRequestsPageState extends State<PgPendingFollowRequestsPage>
    with AppActiveContentInfiniteMixin, AppUserMixin, AppUtilsMixin {
  final _userFollowIds = <int>[];

  @override
  void onLoadEvent() {
    _loadUserFollows(latest: true);
  }

  @override
  onReloadBeforeEvent() {
    _userFollowIds.clear();
    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadUserFollows(latest: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.followRequests),
        leading: GestureDetector(
          onTap: AppNavigation.pop,
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: contentMixinReloadPage,
        child: Stack(
          children: [
            if (isLoadingLatest)
              Positioned(
                top: 0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(5),
                  color: ThemeBloc.colorScheme.background,
                  child: PgUtils.darkCupertinoActivityIndicator(),
                ),
              ),
            ListView.builder(
              itemCount: isLoadingBottom ? _userFollowIds.length + 1 : _userFollowIds.length,
              itemBuilder: (context, index) => _buildUserRequest(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRequest(int index) {
    /*
    |--------------------------------------------------------------------------
    | aggressive prefetching
    |--------------------------------------------------------------------------
    */

    if (_userFollowIds.length - 3 < index) {
      _loadUserFollows(waitForFrame: true);
    }

    /*
    |--------------------------------------------------------------------------
    | check if there are widgets to build:
    |--------------------------------------------------------------------------
    */

    if (_userFollowIds.length > index) {
      var userFollowModel = activeContent.read<UserFollowModel>(_userFollowIds[index]) ?? UserFollowModel.none();
      if (userFollowModel.isNotModel) {
        return AppLogger.fail('${userFollowModel.runtimeType}(${_userFollowIds[index]})');
      }

      var userIdToBuild = AppUtils.intVal(userFollowModel.followedByUserId);

      var userModel = activeContent.read<UserModel>(userIdToBuild) ?? UserModel.none();
      if (userModel.isNotModel) {
        return AppLogger.fail('${userFollowModel.runtimeType}($userIdToBuild)');
      }

      AppTile appTile = AppTile();

      appTile.leading = SizedBox(
        width: 50,
        height: 50,
        child: CircleAvatar(
          backgroundColor: Colors.grey[300],
          backgroundImage: CachedNetworkImageProvider(
            userModel.image,
          ),
        ),
      );

      appTile.title = Text(
        userModel.username,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: ThemeBloc.textInterface.normalBlackH4TextStyle(),
      );

      if (userModel.displayName.isNotEmpty) {
        appTile.subtitle = Text(
          userModel.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: ThemeBloc.textInterface.normalGreyH4TextStyle(),
        );
      }

      appTile.trailing = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ThemeBloc.widgetInterface.themeButton(
            text: AppLocalizations.of(context)!.confirm,
            onTapCallback: () {
              utilMixinSetState(() {
                _userFollowIds.removeAt(index);
              });

              activeContent.apiRepository.preparedRequest(requestType: REQ_TYPE_USER_FOLLOW_ACCEPT, requestData: {
                UserFollowTable.tableName: {UserFollowTable.id: userFollowModel.intId},
              });
            },
          ),
          GestureDetector(
            onTap: () {
              utilMixinSetState(() {
                _userFollowIds.removeAt(index);
              });

              activeContent.apiRepository.preparedRequest(requestType: REQ_TYPE_USER_FOLLOW_IGNORE, requestData: {
                UserFollowTable.tableName: {UserFollowTable.id: userFollowModel.intId},
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                size: 20,
              ),
            ),
          ),
        ],
      );

      return appTile.dispense();
    }

    return PgUtils.darkCupertinoActivityIndicator();
  }

  Future<void> _loadUserFollows({bool latest = false, bool waitForFrame = false}) async {
    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_USER_FOLLOW_PENDING_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_USER_FOLLOW_PENDING_LOAD_BOTTOM,
      requestDataGenerator: () => {
        RequestTable.offset: {
          UserFollowTable.tableName: {UserFollowTable.id: latest ? latestContentId : bottomContentId},
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
      activeContent.pagedModels<UserFollowModel>().forEach((userFollowId, userFollowModel) {
        if (!_userFollowIds.contains(userFollowId)) {
          _userFollowIds.add(userFollowId);
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _userFollowIds.isEmpty ? 0 : _userFollowIds.reduce(max),
        setBottomContentId: _userFollowIds.isEmpty ? 0 : _userFollowIds.reduce(min),
      );
    });
  }
}
