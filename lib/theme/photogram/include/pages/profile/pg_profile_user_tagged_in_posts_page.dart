import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_feed_post_widget.dart';

class PgProfileUserTaggedInPostsPage extends ProfileUserTaggedInPostsPage {
  final int userId;

  final List<int> postUserTagIds;

  final int scrollToPostUserTagIndex;

  const PgProfileUserTaggedInPostsPage({
    Key? key,
    required this.userId,
    required this.postUserTagIds,
    required this.scrollToPostUserTagIndex,
  }) : super(key: key);

  @override
  _PgProfileUserTaggedInPostsPageState createState() => _PgProfileUserTaggedInPostsPageState();
}

class _PgProfileUserTaggedInPostsPageState extends State<PgProfileUserTaggedInPostsPage>
    with AppActiveContentInfiniteMixin, AppUtilsMixin {
  late UserModel _userModel;

  final _postUserTagIds = <int>[];

  @override
  void onLoadEvent() {
    _userModel = activeContent.watch<UserModel>(widget.userId) ?? UserModel.none();

    _postUserTagIds.addAll(widget.postUserTagIds);

    if (_postUserTagIds.isEmpty) {
      _loadPosts(latest: true);
    }
  }

  @override
  onReloadBeforeEvent() {
    _postUserTagIds.clear();
    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadPosts(latest: true);
  }

  @override
  Widget build(BuildContext context) {
    if (_userModel.isNotModel) {
      return AppLogger.fail('${_userModel.runtimeType}(${widget.userId})');
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: AppNavigation.pop,
          child: const Icon(Icons.arrow_back),
        ),
        centerTitle: false,
        title: Text(AppLocalizations.of(context)!.posts),
      ),
      body: RefreshIndicator(
        onRefresh: contentMixinReloadPage,
        child: ScrollablePositionedList.builder(
          itemCount: isLoadingBottom ? _postUserTagIds.length + 1 : _postUserTagIds.length,
          initialScrollIndex: widget.scrollToPostUserTagIndex,
          itemBuilder: (context, index) => _buildPost(index),
        ),
      ),
    );
  }

  Widget _buildPost(int index) {
    // agressive prefetching posts
    if (_postUserTagIds.length - 3 < index) {
      _loadPosts(waitForFrame: true);
    }

    if (_postUserTagIds.length > index) {
      var postUserTagModel = activeContent.watch<PostUserTagModel>(_postUserTagIds[index]) ?? PostUserTagModel.none();
      if (postUserTagModel.isNotModel) {
        return AppLogger.fail('${postUserTagModel.runtimeType}');
      }

      return PgFeedPostWidget(postId: AppUtils.intVal(postUserTagModel.taggedInPostId));
    }

    return PgUtils.darkCupertinoActivityIndicator();
  }

  Future<void> _loadPosts({bool latest = false, bool waitForFrame = false}) async {
    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_POST_USER_TAG_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_POST_USER_TAG_LOAD_BOTTOM,
      requestDataGenerator: () => {
        PostUserTagTable.tableName: {PostUserTagTable.taggedUserId: _userModel.id},
        RequestTable.offset: {
          PostUserTagTable.tableName: {PostUserTagTable.id: latest ? latestContentId : bottomContentId},
        },
      },
    );
  }

  handleResponse({
    bool latest = false,
    required ResponseModel responseModel,
  }) {
    activeContent.handleResponse(responseModel);

    setState(() {
      activeContent.pagedModels<PostUserTagModel>().forEach((postUserTagId, postUserTagModel) {
        if (!_postUserTagIds.contains(postUserTagId)) {
          _postUserTagIds.add(postUserTagId);
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _postUserTagIds.isEmpty ? 0 : _postUserTagIds.reduce(max),
        setBottomContentId: _postUserTagIds.isEmpty ? 0 : _postUserTagIds.reduce(min),
      );
    });
  }
}
