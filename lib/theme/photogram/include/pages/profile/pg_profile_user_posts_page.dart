import 'dart:math';

import 'package:flutter/material.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_feed_post_widget.dart';

class PgProfileUserPostsPage extends ProfileUserPostsPage {
  final int userId;

  final List<int> postIds;

  final int scrollToPostIndex;

  const PgProfileUserPostsPage({
    Key? key,
    required this.userId,
    required this.postIds,
    required this.scrollToPostIndex,
  }) : super(key: key);

  @override
  _PgProfilePostsPageState createState() => _PgProfilePostsPageState();
}

class _PgProfilePostsPageState extends State<PgProfileUserPostsPage> with AppActiveContentInfiniteMixin, AppUtilsMixin {
  late UserModel _userModel;

  /// list of post ids
  final _postIds = <int>[];

  @override
  void onLoadEvent() {
    _userModel = activeContent.watch<UserModel>(widget.userId) ?? UserModel.none();

    _postIds.addAll(widget.postIds);

    if (_postIds.isEmpty) {
      _loadPosts(latest: true);
    }
  }

  @override
  onReloadBeforeEvent() {
    _postIds.clear();
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
          itemCount: isLoadingBottom ? _postIds.length + 1 : _postIds.length,
          initialScrollIndex: widget.scrollToPostIndex,
          itemBuilder: (context, index) => _buildPost(index),
        ),
      ),
    );
  }

  Widget _buildPost(int index) {
    // agressive prefetching posts
    if (_postIds.length - 3 < index) {
      _loadPosts(waitForFrame: true);
    }

    if (_postIds.length > index) {
      return PgFeedPostWidget(postId: _postIds[index]);
    }

    return PgUtils.darkCupertinoActivityIndicator();
  }

  Future<void> _loadPosts({bool latest = false, bool waitForFrame = false}) async {
    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_POST_USER_FEED_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_POST_USER_FEED_LOAD_BOTTOM,
      requestDataGenerator: () => {
        PostTable.tableName: {PostTable.ownerUserId: _userModel.id},
        RequestTable.offset: {
          PostTable.tableName: {PostTable.id: latest ? latestContentId : bottomContentId},
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
      // list of posts
      activeContent.pagedModels<PostModel>().forEach((int postId, PostModel postModel) {
        if (!_postIds.contains(postId)) {
          _postIds.add(postId);
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _postIds.isEmpty ? 0 : _postIds.reduce(max),
        setBottomContentId: _postIds.isEmpty ? 0 : _postIds.reduce(min),
      );
    });
  }
}
