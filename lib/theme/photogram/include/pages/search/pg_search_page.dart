import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/pages/search/pg_search_users_page.dart';

class PgSearchPage extends SearchPage {
  const PgSearchPage({
    Key? key,
  }) : super(key: key);

  @override
  _PgSearchPageState createState() => _PgSearchPageState();
}

class _PgSearchPageState extends State<PgSearchPage>
    with AppActiveContentInfiniteMixin, AppHashtagMixin, AppUtilsMixin {
  final _postIds = <int>[];

  final _infinitePostIds = <int>[];
  var _switchedToInfiniteMode = false;

  @override
  void onLoadEvent() {
    _loadPosts(latest: true);
  }

  @override
  onReloadBeforeEvent() {
    _postIds.clear();
    _infinitePostIds.clear();
    _switchedToInfiniteMode = false;
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
        title: InkWell(
          onTap: _openSearchUsersPage,
          child: IgnorePointer(
            child: ThemeBloc.widgetInterface.primaryTextField(
              context: context,
              focusNode: DisabledFocusNode(),
              hintText: AppLocalizations.of(context)!.search,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: contentMixinReloadPage,
        notificationPredicate: (notification) => notification.depth == 0,
        child: Column(
          children: [
            if (isLoadingLatest) Expanded(child: PgUtils.gridImagePreloaderFull(3)),
            Expanded(
              child: GridView.builder(
                itemCount: isLoadingBottom ? _postIds.length + 12 : _postIds.length,
                itemBuilder: (context, index) => _buildPost(index),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
              ),
            ),
          ],
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
      var postModel = activeContent.watch<PostModel>(_postIds[index]) ?? PostModel.none();
      if (postModel.isNotModel) {
        return AppLogger.fail('${postModel.runtimeType}(${_postIds[index]})');
      }
      if (!postModel.isVisible) {
        return PgUtils.gridImageStationary();
      }

      return GestureDetector(
        onTap: () => _openPostPage(index),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                placeholder: (_, __) => Container(color: Colors.grey[300]),
                imageUrl: postModel.getFirstImageUrlFromPostContent,
                fit: BoxFit.cover,
              ),
            ),
            if (postModel.displayContent.length > 1) PgUtils.postContentIcon()
          ],
        ),
      );
    }

    // add prelaoder
    return PgUtils.gridImagePreloader();
  }

  Future<void> _loadPosts({bool latest = false, bool waitForFrame = false}) async {
    if (_switchedToInfiniteMode) {
      return contentMixinLoadContent(
        latest: false,
        waitForFrame: waitForFrame,
        responseHandler: handleResponse,
        latestEndpoint: '',
        bottomEndpoint: REQ_TYPE_POST_INFINITE_LOAD,
        requestDataGenerator: () => {
          RequestTable.offset: {
            PostTable.tableName: {PostTable.id: _infinitePostIds.isEmpty ? 0 : _infinitePostIds.reduce(min)},
          }
        },
      );
    }

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

    utilMixinSetState(() {
      activeContent.pagedModels<PostModel>().forEach((postId, postModel) {
        if (!_postIds.contains(postId)) {
          _postIds.add(postId);
        }

        if (_switchedToInfiniteMode) {
          if (!_infinitePostIds.contains(postId)) {
            _infinitePostIds.add(postId);
          }
        }
      });

      if (!_switchedToInfiniteMode) {
        contentMixinUpdateData(
          setLatestContentId: _postIds.isEmpty ? 0 : _postIds.reduce(max),
          setBottomContentId: _postIds.isEmpty ? 0 : _postIds.reduce(min),
        );

        if (endOfResults()) {
          _switchedToInfiniteMode = true;

          Future.delayed(Duration.zero, () {
            endOfResults(false);
            _loadPosts();
          });
        }
      }
    });
  }

  void _openPostPage(int scrollToIndex) {
    AppNavigation.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ThemeBloc.pageInterface.searchPostsPage(
            postIds: _postIds,
            scrollToPostIndex: scrollToIndex,
          );
        },
      ),
      utilMixinSetState,
    );
  }

  void _openSearchUsersPage() {
    AppNavigation.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PgSearchUsersPage(),
      ),
      utilMixinSetState,
    );
  }
}
