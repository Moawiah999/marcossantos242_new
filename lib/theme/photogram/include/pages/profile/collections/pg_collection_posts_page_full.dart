import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_feed_post_widget.dart';

class PgCollectionPostsPageFull extends CollectionPostsPageFull {
  final int collectionId;
  final List<int> postSaveIds;
  final int scrollToPostSaveIndex;
  final String defaultAppBarTitle;

  const PgCollectionPostsPageFull({
    Key? key,
    required this.collectionId,
    required this.postSaveIds,
    required this.defaultAppBarTitle,
    required this.scrollToPostSaveIndex,
  }) : super(key: key);

  @override
  PgPostSavesPage createState() => PgPostSavesPage();
}

class PgPostSavesPage extends State<PgCollectionPostsPageFull> with AppActiveContentInfiniteMixin {
  /// parent collection model
  late final CollectionModel _collectionModel;

  /// list of post ids
  final _postSaveIds = <int>[];
  final _postIdsReceived = <int>[];
  final _postSaveIdsReceived = <int>[];

  late final String _collectionTitle;

  @override
  void onLoadEvent() {
    _postSaveIds.addAll(widget.postSaveIds);

    if (LITERAL_ALL_POSTS_COLLECTION_ID == widget.collectionId) {
      _collectionTitle = widget.defaultAppBarTitle;
    } else {
      _collectionModel = activeContent.watch<CollectionModel>(widget.collectionId)!;
      _collectionTitle = _collectionModel.displayTitle;
    }

    _loadPosts(latest: true);
  }

  @override
  onReloadBeforeEvent() {
    _postSaveIds.clear();
    _postSaveIdsReceived.clear();
    _postIdsReceived.clear();
    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadPosts(latest: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_collectionTitle)),
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
            RefreshIndicator(
              onRefresh: contentMixinReloadPage,
              child: ScrollablePositionedList.builder(
                itemCount: isLoadingBottom ? _postSaveIds.length + 1 : _postSaveIds.length,
                initialScrollIndex: widget.scrollToPostSaveIndex,
                itemBuilder: _buildPost,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPost(BuildContext context, int index) {
    // agressive prefetching posts
    if (_postSaveIds.length - 3 < index) {
      _loadPosts(waitForFrame: true);
    }

    if (_postSaveIds.length > index) {
      var postSaveModel = activeContent.read<PostSaveModel>(_postSaveIds[index])!;

      var postIdToBuild = AppUtils.intVal(postSaveModel.savedPostId);

      return PgFeedPostWidget(postId: postIdToBuild);
    }

    return PgUtils.darkCupertinoActivityIndicator();
  }

  Future<void> _loadPosts({bool latest = false, bool waitForFrame = false}) async {
    contentMixinLoadContent(
        latest: latest,
        waitForFrame: waitForFrame,
        responseHandler: handleResponse,
        latestEndpoint: REQ_TYPE_POST_SAVE_LOAD_LATEST,
        bottomEndpoint: REQ_TYPE_POST_SAVE_LOAD_BOTTOM,
        requestDataGenerator: () => {
              PostSaveTable.tableName: {PostSaveTable.savedToCollectionId: widget.collectionId},
              RequestTable.offset: {
                PostSaveTable.tableName: {PostSaveTable.id: (latest) ? latestContentId : bottomContentId},
              },
            });
  }

  handleResponse({
    bool latest = false,
    required ResponseModel responseModel,
  }) {
    setState(() {
      activeContent.handleResponse(responseModel);

      activeContent.pagedModels<PostSaveModel>().forEach((postSaveId, postSaveModel) {
        if (!_postSaveIdsReceived.contains(postSaveId)) {
          _postSaveIdsReceived.add(postSaveId);
        }

        var postId = AppUtils.intVal(postSaveModel.savedPostId);

        // duplicate free
        if (!_postIdsReceived.contains(postId)) {
          _postIdsReceived.add(postId);

          if (!_postSaveIds.contains(postSaveId)) {
            _postSaveIds.add(postSaveId);
          }
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _postSaveIdsReceived.isEmpty ? 0 : _postSaveIdsReceived.reduce(max),
        setBottomContentId: _postSaveIdsReceived.isEmpty ? 0 : _postSaveIdsReceived.reduce(min),
      );
    });
  }
}
