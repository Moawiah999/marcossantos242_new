import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/pages/pg_context.dart';
import 'package:photogram/theme/photogram/include/widgets/bottomsheet/pg_bottom_sheet_action.dart';

class PgCollectionPostsPage extends CollectionPostsPage {
  final int collectionId;
  final String defaultAppBarTitle;

  const PgCollectionPostsPage({
    Key? key,
    required this.collectionId,
    required this.defaultAppBarTitle,
  }) : super(key: key);

  @override
  PgPostSavesPage createState() => PgPostSavesPage();
}

class PgPostSavesPage extends State<PgCollectionPostsPage> with AppActiveContentInfiniteMixin, AppUtilsMixin {
  late final CollectionModel _collectionModel;

  /// list of post ids
  final _postSaveIds = <int>[];
  final _postIdsReceived = <int>[];
  final _postSaveIdsReceived = <int>[];

  late final bool _isAllPostsCollection;
  late final String _collectionTitle;

  @override
  void onLoadEvent() {
    if (LITERAL_ALL_POSTS_COLLECTION_ID == widget.collectionId) {
      _isAllPostsCollection = true;
      _collectionTitle = widget.defaultAppBarTitle;
      _collectionModel = CollectionModel();
    } else {
      _isAllPostsCollection = false;
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
      appBar: AppBar(
        title: Text(_collectionTitle),
        actions: [
          if (!_isAllPostsCollection)
            GestureDetector(
              onTap: () {
                context.showBottomSheet(
                  [
                    PgBottomSheetAction(
                      isRed: true,
                      iconData: Icons.delete_outline,
                      title: AppLocalizations.of(context)!.deleteCollection,
                      onTap: _deleteCollection,
                    ),
                  ],
                );
              },
              child: const Icon(Icons.more_vert),
            ),
        ],
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
            GridView.builder(
              itemCount: isLoadingBottom ? _postSaveIds.length + 1 : _postSaveIds.length,
              itemBuilder: _buildPost,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
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

      var postModel = activeContent.watch<PostModel>(postIdToBuild) ?? PostModel.none();
      if (postModel.isNotModel) {
        return AppLogger.fail('${postModel.runtimeType}($postIdToBuild)');
      }
      if (!postModel.isVisible) {
        return PgUtils.gridImageStationary();
      }

      if ((_isAllPostsCollection && postModel.isNotSaved) ||
          !_isAllPostsCollection && !postModel.savedToCollectionIds.contains(widget.collectionId.toString())) {
        return AppUtils.nothing();
      }

      return GestureDetector(
        onTap: () {
          AppNavigation.push(
            context,
            MaterialPageRoute(
              builder: (_) => ThemeBloc.pageInterface.collectionPostsPageFull(
                defaultAppBarTitle: _collectionTitle,
                collectionId: _isAllPostsCollection ? LITERAL_ALL_POSTS_COLLECTION_ID : _collectionModel.intId,
                postSaveIds: _postSaveIds,
                scrollToPostSaveIndex: _postSaveIds.indexOf(_postSaveIds[index]),
              ),
            ),
            utilMixinSetState,
          );
        },
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: postModel.getFirstImageUrlFromPostContent,
                fit: BoxFit.cover,
              ),
            ),
            if (postModel.displayContent.length > 1) PgUtils.postContentIcon()
          ],
        ),
      );
    }

    // preloader for bottom/top posts
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

  Future<void> _deleteCollection() async {
    await AppProvider.of(context).apiRepo.preparedRequest(
      requestType: REQ_TYPE_COLLECTION_REMOVE,
      requestData: {
        CollectionTable.tableName: {CollectionTable.id: widget.collectionId}
      },
    );

    if (AppNavigation.pop()) {
      AppNavigation.pop();
    }
  }
}
