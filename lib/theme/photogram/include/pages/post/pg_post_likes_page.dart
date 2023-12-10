import 'dart:math';

import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgPostLikesPage extends PostlikesPage {
  final int postId;

  const PgPostLikesPage({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  _PgPostLikesPageState createState() => _PgPostLikesPageState();
}

class _PgPostLikesPageState extends State<PgPostLikesPage>
    with AppActiveContentInfiniteMixin, AppUserMixin, AppUtilsMixin {
  /// parent post model
  late PostModel _postModel;

  /// list of posts like ids
  final _postLikeIds = <int>[];

  /// post like id => user id(the one who liked the post)
  final _mapJoinPostlikeIdOnUserId = <int, int>{};

  @override
  void onLoadEvent() {
    _postModel = activeContent.watch<PostModel>(widget.postId) ?? PostModel.none();

    _loadPostsLikes(latest: true);
  }

  @override
  onReloadBeforeEvent() {
    _postLikeIds.clear();
    _mapJoinPostlikeIdOnUserId.clear();
    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadPostsLikes(latest: true);
  }

  @override
  Widget build(BuildContext context) {
    if (_postModel.isNotModel) {
      return AppLogger.fail('${_postModel.runtimeType}(${widget.postId})');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.likes),
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
              itemCount: isLoadingBottom ? _postLikeIds.length + 1 : _postLikeIds.length,
              itemBuilder: (context, index) => _buildPostlike(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostlike(int index) {
    /*
    |--------------------------------------------------------------------------
    | aggressive prefetching
    |--------------------------------------------------------------------------
    */

    if (_postLikeIds.length - 3 < index) {
      _loadPostsLikes(waitForFrame: true);
    }

    /*
    |--------------------------------------------------------------------------
    | check if there are widgets to build:
    |--------------------------------------------------------------------------
    */

    if (_postLikeIds.length > index) {
      var postLikeIdToBuild = _postLikeIds[index];

      /*
      |--------------------------------------------------------------------------
      | get user model:
      |--------------------------------------------------------------------------
      */

      var userModel =
          activeContent.watch<UserModel>(_mapJoinPostlikeIdOnUserId[postLikeIdToBuild]!) ?? UserModel.none();
      if (userModel.isNotModel) {
        return AppLogger.fail('${userModel.runtimeType}(${_mapJoinPostlikeIdOnUserId[postLikeIdToBuild]!})');
      }

      /*
      |--------------------------------------------------------------------------
      | build user tile:
      |--------------------------------------------------------------------------
      */

      return userMixinBuildUserTile(userModel);
    }

    return PgUtils.darkCupertinoActivityIndicator();
  }

  Future<void> _loadPostsLikes({bool latest = false, bool waitForFrame = false}) async {
    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_POST_LIKE_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_POST_LIKE_LOAD_BOTTOM,
      requestDataGenerator: () => {
        PostLikeTable.tableName: {PostLikeTable.likedPostId: _postModel.id},
        RequestTable.offset: {
          PostLikeTable.tableName: {PostLikeTable.id: latest ? latestContentId : bottomContentId},
        },
      },
    );
  }

  handleResponse({
    bool latest = false,
    required ResponseModel responseModel,
  }) {
    // push to active content first
    activeContent.handleResponse(responseModel);

    utilMixinSetState(() {
      activeContent.pagedModels<PostLikeModel>().forEach((postLikeId, postLikeModel) {
        // list of post likes
        if (!_postLikeIds.contains(postLikeId)) {
          _postLikeIds.add(postLikeId);
        }

        // join on users
        if (!_mapJoinPostlikeIdOnUserId.containsKey(postLikeId)) {
          _mapJoinPostlikeIdOnUserId.addAll({postLikeId: AppUtils.intVal(postLikeModel.likedByUserId)});
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _postLikeIds.isEmpty ? 0 : _postLikeIds.reduce(max),
        setBottomContentId: _postLikeIds.isEmpty ? 0 : _postLikeIds.reduce(min),
      );
    });
  }
}
