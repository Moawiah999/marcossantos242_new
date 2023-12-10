import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgProfileUserPostsGridView extends ProfileUserPostsPage {
  final int userId;

  final String instanceStateId;

  // final StreamController<bool> streamController;

  const PgProfileUserPostsGridView({
    Key? key,
    required this.userId,
    required this.instanceStateId,
    // required this.streamController,
  }) : super(key: key);

  @override
  _PgProfilePostsPageGridState createState() => _PgProfilePostsPageGridState();
}

class _PgProfilePostsPageGridState extends State<PgProfileUserPostsGridView>
    with AutomaticKeepAliveClientMixin<PgProfileUserPostsGridView>, AppActiveContentInfiniteMixin, AppUtilsMixin {
  late UserModel _userModel;

  var _previousInstanceStateId = '';

  @override
  bool get wantKeepAlive {
    var doReload = _previousInstanceStateId != widget.instanceStateId;

    if (doReload) {
      _previousInstanceStateId = widget.instanceStateId;

      utilMixinPostFrame(() {
        contentMixinReloadPage();
      });

      return false;
    }

    return true;
  }

  final _postIds = <int>[];

  @override
  void onLoadEvent() {
    _userModel = activeContent.watch<UserModel>(widget.userId) ?? UserModel.none();

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
    super.build(context);

    if (_userModel.isNotModel) {
      return AppLogger.fail('${_userModel.runtimeType}(${widget.userId})');
    }

    if (_postIds.isEmpty && !isLoadingCallInStack) {
      return _buildInfoSection();
    }

    return Column(
      children: [
        if (isLoadingLatest) Expanded(child: PgUtils.gridImagePreloaderFull(3)),
        Expanded(
          child: GridView.builder(
            itemCount: isLoadingBottom ? _postIds.length + 12 : _postIds.length,
            itemBuilder: _buildPost,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPost(BuildContext context, int index) {
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

      return GestureDetector(
        onTap: () {
          AppNavigation.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ThemeBloc.pageInterface.profileUserPostsPage(
                  userId: widget.userId,
                  postIds: _postIds,
                  scrollToPostIndex: _postIds.indexOf(postIdToBuild),
                );
              },
            ),
            utilMixinSetState,
          );
        },
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

  Widget _buildInfoSection() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(32),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Column(
              children: [
                Text(
                  _userModel.isLoggedIn ? AppLocalizations.of(context)!.profile : AppLocalizations.of(context)!.profile,
                  style: ThemeBloc.textInterface.boldBlackH2TextStyle(),
                  textAlign: TextAlign.center,
                ),
                PgUtils.sizedBoxH(10),
                Text(
                  _userModel.isLoggedIn
                      ? AppLocalizations.of(context)!.whenYouSharePhotosTheyIllAppearHere
                      : AppLocalizations.of(context)!.noPostsToShow,
                  style: ThemeBloc.textInterface.normalGreyH5TextStyle(),
                  textAlign: TextAlign.center,
                ),
                PgUtils.sizedBoxH(10),
                if (_userModel.isLoggedIn)
                  GestureDetector(
                    onTap: () => PgUtils.openCreatePostPage(utilMixinSetState),
                    child: Text(
                      AppLocalizations.of(context)!.shareYourFirstPhoto,
                      style: ThemeBloc.textInterface.normalHrefH5TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
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
