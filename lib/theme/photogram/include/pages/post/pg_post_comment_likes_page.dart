import 'dart:math';

import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgPostCommentLikesPage extends PostCommentLikesPage {
  final int postCommentId;

  const PgPostCommentLikesPage({Key? key, required this.postCommentId}) : super(key: key);

  @override
  _PgPostCommentLikesPageState createState() => _PgPostCommentLikesPageState();
}

class _PgPostCommentLikesPageState extends State<PgPostCommentLikesPage>
    with AppActiveContentInfiniteMixin, AppUserMixin, AppUtilsMixin {
  /// parent post comment
  late PostCommentModel _postCommentModel;

  /// list of posts like ids
  final _postCommentLikeIds = <int>[];

  /// post comment like id => user id(the one who liked the post)
  final _mapJoinPostcommentlikeIdOnUserId = <int, int>{};

  @override
  void onLoadEvent() {
    _postCommentModel = activeContent.watch<PostCommentModel>(widget.postCommentId) ?? PostCommentModel.none();

    _loadPostCommentLikes(latest: true);
  }

  @override
  onReloadBeforeEvent() {
    _postCommentLikeIds.clear();
    _mapJoinPostcommentlikeIdOnUserId.clear();
    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadPostCommentLikes(latest: true);
  }

  @override
  Widget build(BuildContext context) {
    if (_postCommentModel.isNotModel) {
      return AppLogger.fail('${_postCommentModel.runtimeType}(${widget.postCommentId})');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.commentLikes),
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
              itemCount: isLoadingBottom ? _postCommentLikeIds.length + 1 : _postCommentLikeIds.length,
              itemBuilder: (context, index) => _buildPostcommentlike(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostcommentlike(int index) {
    /*
    |--------------------------------------------------------------------------
    | aggressive prefetching
    |--------------------------------------------------------------------------
    */

    if (_postCommentLikeIds.length - 3 < index) {
      _loadPostCommentLikes(waitForFrame: true);
    }

    /*
    |--------------------------------------------------------------------------
    | check if there are widgets to build:
    |--------------------------------------------------------------------------
    */

    if (_postCommentLikeIds.length > index) {
      var postLikeIdToBuild = _postCommentLikeIds[index];

      /*
      |--------------------------------------------------------------------------
      | get user model:
      |--------------------------------------------------------------------------
      */

      var userId = _mapJoinPostcommentlikeIdOnUserId[postLikeIdToBuild]!;

      var userModel = activeContent.watch<UserModel>(userId) ?? UserModel.none();
      if (userModel.isNotModel) {
        return AppLogger.fail('${userModel.runtimeType}($userId)');
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

  Future<void> _loadPostCommentLikes({bool latest = false, bool waitForFrame = false}) async {
    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_POST_COMMENT_LIKE_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_POST_COMMENT_LIKE_LOAD_BOTTOM,
      requestDataGenerator: () => {
        PostCommentLikeTable.tableName: {PostCommentLikeTable.likedPostCommentId: _postCommentModel.id},
        RequestTable.offset: {
          PostCommentLikeTable.tableName: {PostCommentLikeTable.id: latest ? latestContentId : bottomContentId},
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
      activeContent.pagedModels<PostCommentLikeModel>().forEach((postCommentLikeId, postCommentLikeModel) {
        // list of post commetn likes
        if (!_postCommentLikeIds.contains(postCommentLikeId)) {
          _postCommentLikeIds.add(postCommentLikeId);
        }

        // join on users
        if (!_mapJoinPostcommentlikeIdOnUserId.containsKey(postCommentLikeId)) {
          _mapJoinPostcommentlikeIdOnUserId
              .addAll({postCommentLikeId: AppUtils.intVal(postCommentLikeModel.likedByUserId)});
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _postCommentLikeIds.isEmpty ? 0 : _postCommentLikeIds.reduce(max),
        setBottomContentId: _postCommentLikeIds.isEmpty ? 0 : _postCommentLikeIds.reduce(min),
      );
    });
  }
}
