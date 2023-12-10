import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_post_comment_widget.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_post_comments_page_wrapper.dart';

class PgPostCommentRepliesWidget extends PostcommentsPage {
  final int postId;
  final int postCommentId;

  const PgPostCommentRepliesWidget({
    Key? key,
    required this.postId,
    required this.postCommentId,
  }) : super(key: key);

  @override
  PgPostcommentRepliesWidgetState createState() => PgPostcommentRepliesWidgetState();
}

class PgPostcommentRepliesWidgetState extends State<PgPostCommentRepliesWidget>
    with AppActiveContentInfiniteMixin, AppUserMixin, AppUtilsMixin {
  late PostModel _postModel;
  late PostCommentModel _postCommentModel;
  late final PgPostCommentsPageWrapper _postCommentsPageState;

  /// list of posts comments ids
  final _postCommentIds = <int>[];

  /// post like id => user id(the one who liked the post)
  final _mapJoinPostcommentIdOnUserId = <int, int>{};

  var _isHidden = false;

  @override
  void onLoadEvent() {
    _postModel = activeContent.watch<PostModel>(widget.postId) ?? PostModel.none();
    _postCommentModel = activeContent.watch<PostCommentModel>(widget.postCommentId) ?? PostCommentModel.none();

    _postCommentsPageState = PgPostCommentsPageWrapper.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    if (_postModel.isNotModel) {
      return AppLogger.fail('${_postModel.runtimeType}(${widget.postId})');
    }

    if (_postCommentModel.isNotModel) {
      return AppLogger.fail('${_postCommentModel.runtimeType}(${widget.postCommentId})');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCommentRepliesSection(),
        if (!_isHidden)
          ListView(
            shrinkWrap: true,
            addAutomaticKeepAlives: false,
            addSemanticIndexes: false,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (int commentId in _postCommentIds.reversed)
                PgPostCommentWidget(
                  key: Key('$commentId'),
                  postCommentId: commentId,
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildCommentRepliesSection() {
    if (_postCommentModel.cacheCommentsCount < 1) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
          child: Row(
            children: [
              SizedBox(width: 28, height: 2, child: ThemeBloc.widgetInterface.divider()),
              PgUtils.sizedBoxW(20),
              _buildViewMoreRepliesButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewMoreRepliesButton() {
    if (isLoadingCallInStack) {
      return ThemeBloc.textInterface.normalGreyH6Text(text: AppLocalizations.of(context)!.loading);
    }

    if (_isHidden) {
      return GestureDetector(
        onTap: () => utilMixinSetState(() {
          _isHidden = false;
        }),
        child: ThemeBloc.textInterface.normalGreyH6Text(
          text: sprintf(
            AppLocalizations.of(context)!.viewAllNReplies,
            [AppUtils.compactNumber(_postCommentModel.cacheCommentsCount)],
          ),
        ),
      );
    }

    // show hide toggle if all are fetched and present in view
    if (_postCommentModel.cacheCommentsCount == _postCommentIds.length) {
      return GestureDetector(
        onTap: () => utilMixinSetState(() {
          _isHidden = true;
        }),
        child: ThemeBloc.textInterface.normalGreyH6Text(text: AppLocalizations.of(context)!.hideAllReplies),
      );
    }

    return GestureDetector(
      onTap: () {
        _loadPostCommentReplies();
      },
      child: ThemeBloc.textInterface.normalGreyH6Text(
        text: _postCommentModel.cacheCommentsCount - _postCommentIds.length > 100
            ? AppLocalizations.of(context)!.viewMorePreviousReplies
            : sprintf(
                _postCommentIds.isEmpty
                    ? AppLocalizations.of(context)!.viewAllNReplies
                    : AppLocalizations.of(context)!.viewPreviousNReplies,
                [AppUtils.compactNumber(_postCommentModel.cacheCommentsCount - _postCommentIds.length)],
              ),
      ),
    );
  }

  Future<void> _loadPostCommentReplies() async {
    var latest = _postCommentIds.isEmpty;

    contentMixinLoadContent(
      latest: latest,
      waitForFrame: false,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_POST_COMMENT_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_POST_COMMENT_LOAD_BOTTOM,
      requestDataGenerator: () => {
        PostCommentTable.tableName: {
          PostCommentTable.parentPostId: _postModel.id,
          PostCommentTable.replyToPostCommentId: _postCommentModel.id,
        },
        RequestTable.offset: {
          PostCommentTable.tableName: {PostCommentTable.id: latest ? latestContentId : bottomContentId},
        }
      },
    );
  }

  handleResponse({
    bool latest = false,
    required ResponseModel responseModel,
  }) {
    // push to active content first
    activeContent.handleResponse(responseModel);

    setState(() {
      activeContent.pagedModels<PostCommentModel>().forEach((postCommentId, postCommentModel) {
        // prevent parent dependency(only one model)
        if (postCommentModel.replyToPostCommentId == _postCommentModel.replyToPostCommentId) return;

        // prevent parent stuffed replies
        if (!_postCommentsPageState.getPostcommentIdsToIgnore.contains(postCommentModel.intId)) {
          // list of post comments
          if (!_postCommentIds.contains(postCommentId)) {
            _postCommentIds.add(postCommentId);
          }
        }

        // join on users
        if (!_mapJoinPostcommentIdOnUserId.containsKey(postCommentId)) {
          _mapJoinPostcommentIdOnUserId.addAll({postCommentId: AppUtils.intVal(postCommentModel.ownerUserId)});
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _postCommentIds.isEmpty ? 0 : _postCommentIds.reduce(max),
        setBottomContentId: _postCommentIds.isEmpty ? 0 : _postCommentIds.reduce(min),
      );
    });
  }
}
