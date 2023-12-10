import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_feed_post_widget.dart';

class PgSearchPostsPage extends SearchPostsPage {
  final List<int> postIds;
  final int scrollToPostIndex;

  const PgSearchPostsPage({
    Key? key,
    required this.postIds,
    required this.scrollToPostIndex,
  }) : super(key: key);

  @override
  _PgSearchPostsPageState createState() => _PgSearchPostsPageState();
}

class _PgSearchPostsPageState extends State<PgSearchPostsPage> with AppActiveContentInfiniteMixin, AppUtilsMixin {
  final _postIds = <int>[];

  @override
  void onLoadEvent() {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(AppLocalizations.of(context)!.explore),
      ),
      body: RefreshIndicator(
        onRefresh: contentMixinReloadPage,
        child: ScrollablePositionedList.builder(
          itemCount: isLoadingBottom ? _postIds.length + 1 : _postIds.length,
          initialScrollIndex: widget.scrollToPostIndex,
          itemBuilder: _buildPost,
        ),
      ),
    );
  }

  Widget _buildPost(BuildContext context, int index) {
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
      latestEndpoint: REQ_TYPE_HASHTAG_POST_GLOBAL_FEED_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_HASHTAG_POST_GLOBAL_FEED_LOAD_BOTTOM,
      requestDataGenerator: () => {
        RequestTable.offset: {
          HashtagPostTable.tableName: {HashtagPostTable.postId: (latest) ? latestContentId : bottomContentId},
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
      activeContent.pagedModels<PostModel>().forEach((postId, postModel) {
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
