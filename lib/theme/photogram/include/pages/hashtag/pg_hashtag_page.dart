import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pg_data_utils.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/profile/pg_menu_item_widget.dart';

class PgHashtagPage extends HashtagPage {
  final int hashtagId;
  final String hashtag;

  const PgHashtagPage({
    Key? key,
    required this.hashtagId,
    required this.hashtag,
  }) : super(key: key);

  @override
  _PgHashtagPageState createState() => _PgHashtagPageState();
}

class _PgHashtagPageState extends State<PgHashtagPage>
    with AppActiveContentInfiniteMixin, AppHashtagMixin, AppUtilsMixin {
  late HashtagModel _hashtagModel;

  var _hashtagId = 0;

  Widget? _hashtagImage;

  final _postIds = <int>[];

  var _hashtagLoadingInProgress = false;

  @override
  void onLoadEvent() {
    _hashtagId = widget.hashtagId;

    _hashtagModel = activeContent.watch<HashtagModel>(_hashtagId) ?? HashtagModel.none();

    if (_hashtagModel.isNotModel) {
      _loadHashtag();
    }

    _loadPosts(latest: true);
  }

  @override
  onReloadBeforeEvent() {
    _postIds.clear();
    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadHashtag();
    _loadPosts(latest: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: ThemeBloc.textInterface.boldBlackH1Text(text: "#${widget.hashtag}"),
      ),
      body: _hashtagModel.isNotModel
          ? Center(
              child: PgUtils.darkCupertinoActivityIndicator(),
            )
          : RefreshIndicator(
              onRefresh: contentMixinReloadPage,
              notificationPredicate: (notification) => notification.depth == 1,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(child: _buildHashtagHeader()),
                ],
                body: Column(
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
            ),
    );
  }

  Widget _buildHashtagHeader() {
    return Material(
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 36),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: _hashtagImage ?? PgUtils.circularImageStationary(),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () => _openPostPage(0),
                        child: PgMenuItemWidget(
                          title: AppUtils.compactNumber(
                            _hashtagModel.cachePostsCount,
                          ),
                          content: AppLocalizations.of(context)!.posts,
                        ),
                      ),
                      PgUtils.sizedBoxH(10),
                      _createRelationshipButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPost(int index) {
    // agressive prefetching posts
    if (_postIds.length - 3 < index) {
      _loadPosts(waitForFrame: true);
    }

    if (_postIds.length > index) {
      var postIdToBuild = _postIds[index];

      var postModel = activeContent.watch<PostModel>(postIdToBuild) ?? PostModel.none();
      if (postModel.isNotModel) {
        return AppLogger.fail('${postModel.runtimeType}($postIdToBuild)');
      }
      if (!postModel.isVisible) {
        return PgUtils.gridImageStationary();
      }

      _hashtagImage ??= CachedNetworkImage(
        imageUrl: postModel.getFirstImageUrlFromPostContent,
        imageBuilder: (context, imageProvider) {
          return CircleAvatar(backgroundImage: imageProvider);
        },
      );

      return GestureDetector(
        onTap: () => _openPostPage(index),
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

    // add prelaoder
    return PgUtils.gridImagePreloader();
  }

  Widget _createRelationshipButton() {
    if (_hashtagModel.isFollowing) {
      return ThemeBloc.widgetInterface.hollowButton(
        text: AppLocalizations.of(context)!.following,
        onTapCallback: () => hashtagMixinFollowUser(_hashtagModel, false),
      );
    }

    return ThemeBloc.widgetInterface.themeButton(
      text: AppLocalizations.of(context)!.follow,
      onTapCallback: () => hashtagMixinFollowUser(_hashtagModel, true),
    );
  }

  Future<void> _loadPosts({bool latest = false, bool waitForFrame = false}) async {
    if (_hashtagModel.isNotModel) return;

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

    utilMixinSetState(() {
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

  Future<void> _loadHashtag() async {
    if (_hashtagLoadingInProgress) return;
    _hashtagLoadingInProgress = true;

    ResponseModel responseModel;

    if (0 == _hashtagId) {
      responseModel = await AppProvider.of(context).apiRepo.hashtagByDisplayText(hashtag: widget.hashtag);
    } else {
      responseModel = await AppProvider.of(context).apiRepo.hashtagById(hashtagId: _hashtagId.toString());
    }

    // directly parse and get id of hashtag returned
    var hashtagModel = PgDataUtils.hashtagModelFromResponse(responseModel);

    if (hashtagModel.isModel) {
      // we want main app state manager to handle response infact
      activeContent.handleResponse(responseModel);

      // always! get model from state manager so we can stay up to date
      hashtagModel = activeContent.read<HashtagModel>(hashtagModel.intId) ?? HashtagModel.none();
    }

    if (hashtagModel.isNotModel) {
      utilMixinSomethingWentWrongMessage();
      return;
    }

    _hashtagId = hashtagModel.intId;

    _hashtagModel = hashtagModel;

    _loadPosts(latest: true);

    _hashtagLoadingInProgress = false;
  }

  void _openPostPage(int scrollToIndex) {
    AppNavigation.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ThemeBloc.pageInterface.hashtagPostsPage(
            hashtag: widget.hashtag,
            hashtagId: _hashtagModel.intId,
            hashtagPostIds: _postIds,
            scrollToPostIndex: scrollToIndex,
          );
        },
      ),
      utilMixinSetState,
    );
  }
}
