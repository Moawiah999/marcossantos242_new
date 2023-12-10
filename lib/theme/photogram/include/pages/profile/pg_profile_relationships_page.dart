import 'dart:math';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgProfileRelationshipsPage extends ProfileRelationshipsPage {
  final int userId;
  final bool typeFollowers;

  const PgProfileRelationshipsPage({
    Key? key,
    required this.userId,
    required this.typeFollowers,
  }) : super(key: key);

  @override
  _ProfileRelationshipsPageState createState() => _ProfileRelationshipsPageState();
}

class _ProfileRelationshipsPageState extends State<PgProfileRelationshipsPage>
    with AppActiveContentInfiniteMixin, AppUserMixin, AppUtilsMixin {
  late UserModel _userModel;

  /// list of posts like ids
  final _followIds = <int>[];

  /// follow id => user id(the one who followed/followed by the user)
  final _followIdOnUserIdJoinMap = <int, int>{};

  /// additional, post id => post like id
  final _followedUsersMap = <int, int>{};

  @override
  void onLoadEvent() {
    _userModel = activeContent.watch<UserModel>(widget.userId) ?? UserModel.none();

    _loadRelationships(latest: true);
  }

  @override
  onReloadBeforeEvent() {
    _followIds.clear();
    _followIdOnUserIdJoinMap.clear();
    _followedUsersMap.clear();
    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadRelationships(latest: true);
  }

  @override
  Widget build(BuildContext context) {
    if (_userModel.isNotModel) {
      return AppLogger.fail('${_userModel.runtimeType}(${widget.userId})');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.typeFollowers ? AppLocalizations.of(context)!.followers : AppLocalizations.of(context)!.following,
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
                  color: Theme.of(context).colorScheme.background,
                  child: PgUtils.darkCupertinoActivityIndicator(),
                ),
              ),
            ListView.builder(
              itemCount: isLoadingBottom ? _followIds.length + 1 : _followIds.length,
              itemBuilder: (context, index) => _buildUserTile(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(int index) {
    // agressive prefetching posts
    if (_followIds.length - 3 < index) {
      _loadRelationships(waitForFrame: true);
    }

    if (_followIds.length > index) {
      var followIdToBuild = _followIds[index];

      var userModel = activeContent.watch<UserModel>(_followIdOnUserIdJoinMap[followIdToBuild]!) ?? UserModel.none();
      if (userModel.isNotModel) {
        return AppLogger.fail('${userModel.runtimeType}(${_followIdOnUserIdJoinMap[followIdToBuild]!})');
      }

      return userMixinBuildUserTile(userModel);
    }

    return PgUtils.darkCupertinoActivityIndicator();
  }

  Future<void> _loadRelationships({bool latest = false, bool waitForFrame = false}) async {
    var latestEndpoint = (widget.typeFollowers)
        ? REQ_TYPE_USER_FOLLOW_PROFILE_FOLLOWERS_LOAD_LATEST
        : REQ_TYPE_USER_FOLLOW_PROFILE_FOLLOWINGS_LOAD_LATEST;

    var bottomEndpoint = (widget.typeFollowers)
        ? REQ_TYPE_USER_FOLLOW_PROFILE_FOLLOWERS_LOAD_BOTTOM
        : REQ_TYPE_USER_FOLLOW_PROFILE_FOLLOWINGS_LOAD_BOTTOM;

    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: latestEndpoint,
      bottomEndpoint: bottomEndpoint,
      requestDataGenerator: () {
        if (latest) {
          return {
            UserTable.tableName: {UserTable.id: _userModel.id},
            RequestTable.offset: {
              UserFollowTable.tableName: {UserFollowTable.id: latestContentId},
            },
          };
        } else {
          return {
            UserTable.tableName: {UserTable.id: _userModel.id},
            RequestTable.offset: {
              UserFollowTable.tableName: {UserFollowTable.id: bottomContentId},
            },
          };
        }
      },
    );
  }

  handleResponse({
    bool latest = false,
    required ResponseModel responseModel,
  }) {
    activeContent.handleResponse(responseModel);

    utilMixinSetState(() {
      activeContent.pagedModels<UserFollowModel>().forEach((followId, followModel) {
        // list of follows
        if (!_followIds.contains(followId)) {
          _followIds.add(followId);
        }

        // join on users
        if (!_followIdOnUserIdJoinMap.containsKey(followId)) {
          if (widget.typeFollowers) {
            _followIdOnUserIdJoinMap.addAll({followId: AppUtils.intVal(followModel.followedByUserId)});
          } else {
            _followIdOnUserIdJoinMap.addAll({followId: AppUtils.intVal(followModel.followedUserId)});
          }
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _followIds.isEmpty ? 0 : _followIds.reduce(max),
        setBottomContentId: _followIds.isEmpty ? 0 : _followIds.reduce(min),
      );
    });
  }
}
