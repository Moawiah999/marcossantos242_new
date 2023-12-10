import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_post_comment_replies_widget.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_post_comments_page_wrapper.dart';
import 'package:sprintf/sprintf.dart';

class PgPostCommentWidget extends StatefulWidget {
  final int postCommentId;

  const PgPostCommentWidget({
    Key? key,
    required this.postCommentId,
  }) : super(key: key);

  @override
  State<PgPostCommentWidget> createState() => _PgPostCommentWidgetState();
}

class _PgPostCommentWidgetState extends State<PgPostCommentWidget>
    with AppActiveContentMixin, AppPostMixin, AppUtilsMixin {
  late final PgPostCommentsPageWrapper _postCommentsPageState;

  late PostCommentModel _postCommentModel;
  late PostModel _postModel;
  late UserModel _userModel;

  var _isReadingMore = false;

  @override
  void onLoadEvent() {
    _postCommentModel =
        activeContent.watch<PostCommentModel>(widget.postCommentId) ?? PostCommentModel.none();
    _userModel =
        activeContent.watch<UserModel>(AppUtils.intVal(_postCommentModel.ownerUserId)) ?? UserModel.none();
    _postModel =
        activeContent.watch<PostModel>(AppUtils.intVal(_postCommentModel.parentPostId)) ?? PostModel.none();

    _postCommentsPageState = PgPostCommentsPageWrapper.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    if (_postCommentModel.isNotModel) {
      return AppLogger.fail('${_postCommentModel.runtimeType}(${widget.postCommentId})');
    }

    if (_userModel.isNotModel) {
      return AppLogger.fail('${_userModel.runtimeType}(${_postCommentModel.ownerUserId})');
    }

    if (_postCommentModel.isNotModel) {
      return AppLogger.fail('${_postCommentModel.runtimeType}(${_postCommentModel.parentPostId})');
    }

    return Column(
      children: [
        _buildPostcomment(),

        // add comment replies(if comment it-self is not a reply)
        if (_postCommentModel.cacheCommentsCount > 0 && !_postCommentIsAReply())
          PgPostCommentRepliesWidget(postId: _postModel.intId, postCommentId: _postCommentModel.intId),
      ],
    );
  }

  Widget _buildPostcomment() {
    return GestureDetector(
      onLongPress: _handleLongPress,
      child: Container(
        color: (_isCurrentPostCommentSelected())
            ? ThemeBloc.colorScheme.secondary
            : ThemeBloc.colorScheme.background,
        padding: _postCommentIsAReply()
            ? const EdgeInsets.only(top: 10, bottom: 10, right: 16, left: 42)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // user avatar
            SizedBox(
              child: GestureDetector(
                onTap: _openProfilePage,
                child: CircleAvatar(
                  maxRadius: 16,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: CachedNetworkImageProvider(_userModel.image),
                ),
              ),
            ),
            // rest of the comment
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPostcommentBody(),
                      _buildPostcommentOptions(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostcommentBody() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  // username
                  TextSpan(
                    text: _userModel.username,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => PgUtils.openProfilePage(context, _userModel.intId, utilMixinSetState),
                    style: ThemeBloc.textInterface.boldBlackH4TextStyle(),
                  ),
                  // space
                  const TextSpan(text: ' '),

                  // post display text
                  TextSpan(
                    text: (_postCommentModel.displayText.length > COMMENT_TEXT_WRAP_THRESHOLD &&
                            !_isReadingMore)
                        ? _postCommentModel.displayText.substring(0, COMMENT_TEXT_WRAP_THRESHOLD)
                        : _postCommentModel.displayText,
                    style: ThemeBloc.textInterface.normalBlackH4TextStyle(),
                  ),

                  // space
                  const TextSpan(text: ' '),

                  // show more utility
                  if (_postCommentModel.displayText.length > COMMENT_TEXT_WRAP_THRESHOLD && !_isReadingMore)
                    TextSpan(
                      text: AppLocalizations.of(context)!.showMore,
                      recognizer: TapGestureRecognizer()..onTap = () => readMore(true),
                      style: ThemeBloc.textInterface.normalGreyH4TextStyle(),
                    )
                  else if (_postCommentModel.displayText.length > COMMENT_TEXT_WRAP_THRESHOLD)
                    TextSpan(
                      text: AppLocalizations.of(context)!.showLess,
                      recognizer: TapGestureRecognizer()..onTap = () => readMore(false),
                      style: ThemeBloc.textInterface.normalGreyH4TextStyle(),
                    ),
                ],
              ),
            ),
            PgUtils.sizedBoxH(4),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppTimeAgoParser.parseShort(_postCommentModel.stampRegistration),
                    style: ThemeBloc.textInterface.normalGreyH5TextStyle(),
                  ),
                  const TextSpan(text: '    '),
                  if (_postCommentModel.cacheLikesCount > 0)
                    TextSpan(
                      text: sprintf(AppLocalizations.of(context)!.nLikes,
                          [AppUtils.compactNumber(_postCommentModel.cacheLikesCount)]),
                      recognizer: TapGestureRecognizer()..onTap = _openPostCommentLikesPage,
                      style: ThemeBloc.textInterface.normalGreyH5TextStyle(),
                    ),
                  const TextSpan(text: '    '),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _postCommentsPageState.updateNotifier(
                          //
                          selectedPostcommentId: 0,
                          //
                          replyingToPostcommentId: _postCommentModel.intId,
                          //
                          replyingToActualPostcommentId:
                              // reply always to a top level comment to keep the thread clean
                              (_postCommentModel.replyToPostCommentId == "0")
                                  ? _postCommentModel.intId
                                  : AppUtils.intVal(_postCommentModel.replyToPostCommentId),
                        );
                      },
                    text: AppLocalizations.of(context)!.reply,
                    style: ThemeBloc.textInterface.normalGreyH5TextStyle(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostcommentOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: (_postCommentModel.isLiked)
          ? GestureDetector(
              onTap: () => postMixinLikePostcomment(_postCommentModel, false),
              child: const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 16,
              ),
            )
          : GestureDetector(
              onTap: () => postMixinLikePostcomment(_postCommentModel, true),
              child: const Icon(Icons.favorite_outline, size: 16),
            ),
    );
  }

  bool readMore([bool? readMore]) {
    if (readMore != null) {
      utilMixinSetState(() {
        _isReadingMore = readMore;
      });
    }

    return _isReadingMore;
  }

  void _openProfilePage() => PgUtils.openProfilePage(context, _userModel.intId, utilMixinSetState);

  void _openPostCommentLikesPage() =>
      PgUtils.openPostCommentLikesPage(context, _postCommentModel.intId, utilMixinSetState);

  bool _postCommentIsAReply() => _postCommentModel.replyToPostCommentId != "0";

  bool _isCurrentPostCommentSelected() =>
      _postCommentModel.intId == _postCommentsPageState.selectedPostcommentId;

  void _handleLongPress() {
    if (_isCurrentPostCommentSelected()) {
      _postCommentsPageState.clearNotifier();
    } else {
      _postCommentsPageState.updateNotifier(
        selectedPostcommentId: _postCommentModel.intId,
        replyingToPostcommentId: 0,
        replyingToActualPostcommentId: 0,
      );
    }
  }
}
