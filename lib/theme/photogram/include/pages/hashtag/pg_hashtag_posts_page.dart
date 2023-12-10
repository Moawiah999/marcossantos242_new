import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_feed_post_widget.dart';

class PgHashtagPostsPage extends HashtagPostsPage {
  final int hashtagId;
  final String hashtag;

  final List<int> hashtagPostIds;

  final int scrollToPostIndex;

  const PgHashtagPostsPage({
    Key? key,
    required this.hashtagId,
    required this.hashtag,
    required this.hashtagPostIds,
    required this.scrollToPostIndex,
  }) : super(key: key);

  @override
  _PgHashtagPostsPageState createState() => _PgHashtagPostsPageState();
}

class _PgHashtagPostsPageState extends State<PgHashtagPostsPage> with AppActiveContentInfiniteMixin, AppUtilsMixin {
  late HashtagModel _hashtagModel;

  final _postIds = <int>[];

  @override
  void onLoadEvent() {
    _hashtagModel = activeContent.watch<HashtagModel>(widget.hashtagId) ?? HashtagModel.none();

    _postIds.addAll(widget.hashtagPostIds);

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
    if (_hashtagModel.isNotModel) {
      return AppLogger.fail('${_hashtagModel.runtimeType}(${widget.hashtagId})');
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("#${widget.hashtag} - ${AppLocalizations.of(context)!.posts}"),
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
      latestEndpoint: REQ_TYPE_HASHTAG_POST_HASHTAG_FEED_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_HASHTAG_POST_HASHTAG_FEED_LOAD_BOTTOM,
      requestDataGenerator: () => {
        HashtagPostTable.tableName: {HashtagPostTable.hashtagId: _hashtagModel.id},
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
