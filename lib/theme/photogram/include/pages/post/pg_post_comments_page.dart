import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_post_comment_widget.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_post_comments_page_wrapper.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sprintf/sprintf.dart';

class PgPostCommentsPage extends PostcommentsPage {
  final int postId;
  final bool focus;

  const PgPostCommentsPage({
    Key? key,
    required this.postId,
    required this.focus,
  }) : super(key: key);

  @override
  PgPostCommentsPageState createState() => PgPostCommentsPageState();
}

class PgPostCommentsPageState extends State<PgPostCommentsPage>
    with AppActiveContentInfiniteMixin, AppUserMixin, AppUtilsMixin {
  final _focusNode = FocusNode();
  final _postCommentInputController = TextEditingController();
  final _postCommentsScrollController = ItemScrollController();
  late final PgPostCommentsPageWrapper _postCommentsPageState;

  /// parent post model
  late PostModel _postModel;

  final _postCommentIds = <int>[];
  final _postCommentIdOnUserIdJoinMap = <int, int>{};
  final _stuffedPostcommentReplyIds = <int, List<int>>{};

  var _postCommentSubmitLastError = '';

  var _isPostCommentInputFocused = false;
  var _isPostcommentSubmitInProgress = false;
  var _isPostcommentDeleteInProgress = false;

  @override
  void onLoadEvent() {
    _postModel = activeContent.watch<PostModel>(widget.postId) ?? PostModel.none();

    _postCommentsPageState = PgPostCommentsPageWrapper.of(context)!;
    _focusNode.addListener(() => _isPostCommentInputFocused = _focusNode.hasFocus);
    _isPostCommentInputFocused = widget.focus;
    _loadPostcomments(latest: true);
  }

  @override
  void onDisposeEvent() {
    _focusNode.dispose();
    _postCommentInputController.dispose();
  }

  @override
  onReloadBeforeEvent() {
    _postCommentSubmitLastError = '';

    _isPostCommentInputFocused = false;
    _isPostcommentSubmitInProgress = false;
    _isPostcommentDeleteInProgress = false;

    _postCommentIds.clear();
    _postCommentIdOnUserIdJoinMap.clear();
    _stuffedPostcommentReplyIds.clear();

    _postCommentsPageState.clearNotifier();
    _postCommentsPageState.clearPostcommentIdsToIgnore();
    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadPostcomments(latest: true);
  }

  @override
  Widget build(BuildContext context) {
    if (_postModel.isNotModel) {
      return AppLogger.fail('${_postModel.runtimeType}(${widget.postId})');
    }

    return ValueListenableBuilder(
      valueListenable: _postCommentsPageState.notifier,
      builder: (context, PostcommentsPageState pageState, _widget) {
        return Scaffold(
          appBar: _buildAppBar(),
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
                _buildPostcommentsSection(),
                _buildPostcommentInput(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostcommentsSection() {
    return Column(
      children: [
        Expanded(
          child: ScrollablePositionedList.builder(
            itemScrollController: _postCommentsScrollController,
            itemCount: (_postCommentIds.length * 3) + (isLoadingBottom ? 3 : 0),
            itemBuilder: (context, index) {
              switch (index % 3) {
                case 0:
                  return _buildItemStart(index ~/ 3);
                case 1:
                  return _buildItemMiddle(index ~/ 3);
                default:
                  return _buildItemEnd(index ~/ 3);
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildItemStart(index) {
    if (0 == index) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildPostHeader(),
          PgUtils.sizedBoxH(10),
          ThemeBloc.widgetInterface.divider(),
          PgUtils.sizedBoxH(10),
        ],
      );
    }

    return AppUtils.nothing();
  }

  Widget _buildItemMiddle(index) {
    if (0 == index) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          if (_isPostcommentSubmitInProgress && 0 == _postCommentsPageState.replyingToActualPostcommentId)
            _buildPostcommentPlaceholder(
                activeContent.authBloc.getCurrentUser, _postCommentInputController.value.text),
          _buildPostcomment(index)
        ],
      );
    }

    return _buildPostcomment(index);
  }

  Widget _buildItemEnd(index) {
    if (index >= _postCommentIds.length) return AppUtils.nothing();

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // replying to a comment placeholder
        if (_isPostcommentSubmitInProgress &&
            index == _postCommentIds.indexOf(_postCommentsPageState.replyingToActualPostcommentId))
          _buildPostcommentPlaceholder(
            activeContent.authBloc.getCurrentUser,
            _postCommentInputController.value.text,
            true,
          ),

        // stuffed replies
        if (_stuffedPostcommentReplyIds.containsKey(_postCommentIds[index]))
          for (int replyId in _stuffedPostcommentReplyIds[_postCommentIds[index]]!.reversed)
            PgPostCommentWidget(postCommentId: replyId),

        // extra space in the end
        if (index + 1 == _postCommentIds.length) PgUtils.sizedBoxH(80),
      ],
    );
  }

  Widget _buildPostcomment(int index) {
    if (_postCommentIds.length - 3 < index) {
      _loadPostcomments(waitForFrame: true);
    }

    if (_postCommentIds.length > index) {
      return PgPostCommentWidget(postCommentId: _postCommentIds[index]);
    }

    // preloader for bottom/top posts
    return PgUtils.darkCupertinoActivityIndicator();
  }

  Widget _buildReplyingToHeader() {
    var postCommentModel = (0 != _postCommentsPageState.replyingToPostcommentId)
        ? (activeContent.watch<PostCommentModel>(_postCommentsPageState.replyingToPostcommentId) ??
            PostCommentModel())
        : PostCommentModel();
    if (postCommentModel.isNotModel) {
      return AppLogger.fail('${postCommentModel.runtimeType}(${postCommentModel.intId})');
    }

    var userModel =
        activeContent.watch<UserModel>(AppUtils.intVal(postCommentModel.ownerUserId)) ?? UserModel.none();
    if (userModel.isNotModel) {
      return AppLogger.fail('${userModel.runtimeType}(${userModel.intId})');
    }

    return Container(
      color: ThemeBloc.colorScheme.onBackground.withOpacity(0.2),
      child: ListTile(
        dense: true,
        title: Text(
          sprintf(AppLocalizations.of(context)!.replyingTo, [userModel.username]),
          style: ThemeBloc.textInterface.normalGreyH5TextStyle().copyWith(overflow: TextOverflow.ellipsis),
        ),
        trailing: GestureDetector(
          onTap: _postCommentsPageState.clearNotifier,
          child: ThemeBloc.textInterface.normalGreyH5Text(text: 'X'),
        ),
      ),
    );
  }

  Widget _buildPostcommentInput() {
    return Positioned(
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      child: Container(
        alignment: Alignment.topCenter,
        color: ThemeBloc.colorScheme.background,
        child: Column(
          children: [
            if (_postCommentsPageState.isReplyingToAPostcomment()) _buildReplyingToHeader(),
            ThemeBloc.widgetInterface.divider(),
            listEmojis(),
            _buildInputBox(),
          ],
        ),
      ),
    );
  }

  listEmojis() {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _emojiText('❤️'),
            _emojiText('🙌'),
            _emojiText('🔥'),
            _emojiText('👏🏻'),
            _emojiText('😢'),
            _emojiText('😍'),
            _emojiText('😮'),
            _emojiText('😂'),
          ],
        ),
      )
    ]);
  }

  Widget _emojiText(String emoji) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
        _postCommentInputController.text = _postCommentInputController.text + emoji;
        _postCommentInputController.selection =
            TextSelection.fromPosition(TextPosition(offset: _postCommentInputController.text.length));
      },
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildInputBox() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            child: GestureDetector(
              onTap: () => PgUtils.openProfilePage(
                  context, activeContent.authBloc.getCurrentUser.intId, utilMixinSetState),
              child: CachedNetworkImage(
                imageUrl: activeContent.authBloc.getCurrentUser.image,
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                    backgroundImage: imageProvider,
                    maxRadius: 17,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xff9E9E9E), width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: IgnorePointer(
                  ignoring: _isPostcommentSubmitInProgress,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          autofocus: _isPostCommentInputFocused,
                          focusNode: _focusNode,
                          key: KeyGen.from(AppWidgetKey.addCommentPostCommentsPageTextField),
                          maxLines: 4,
                          minLines: 1,
                          controller: _postCommentInputController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "${AppLocalizations.of(context)!.addAComment}...",
                            hintStyle: const TextStyle(color: Color(0xff9E9E9E), fontSize: 14),
                            isDense: true,
                            errorStyle: ThemeBloc.getThemeData.textTheme.headline6
                                ?.copyWith(color: ThemeBloc.getThemeData.errorColor),
                            errorText:
                                _postCommentSubmitLastError.isEmpty ? null : _postCommentSubmitLastError,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _sumbitUserComment,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            AppLocalizations.of(context)!.post,
                            style: const TextStyle(color: Color(0xff9E9E9E), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    if (_postCommentsPageState.isPostcommentSelected()) {
      var postCommentModel =
          activeContent.watch<PostCommentModel>(_postCommentsPageState.selectedPostcommentId) ??
              PostCommentModel.none();

      if (postCommentModel.isModel) {
        return AppBar(
          backgroundColor: ThemeBloc.colorScheme.primary,
          title: Text(
            AppLocalizations.of(context)!.oneSelected,
            style: const TextStyle().copyWith(
              color: ThemeBloc.colorScheme.onPrimary,
            ),
          ),
          leading: GestureDetector(
            onTap: _isPostcommentDeleteInProgress ? () {} : _postCommentsPageState.clearNotifier,
            child: Icon(
              Icons.close,
              color: ThemeBloc.colorScheme.onPrimary,
            ),
          ),
          actions: [
            if (postCommentModel.ownerUserId == activeContent.authBloc.getCurrentUser.id)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  onTap: _isPostcommentDeleteInProgress ? () {} : () => _deletePostcomment(postCommentModel),
                  child: Icon(
                    _isPostcommentDeleteInProgress ? Icons.hourglass_top_outlined : Icons.delete_outline,
                    color: ThemeBloc.colorScheme.onPrimary,
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () => _postCommentsPageState.updateNotifier(
                    selectedPostcommentId: 0,
                    replyingToPostcommentId: postCommentModel.intId,
                    replyingToActualPostcommentId: (postCommentModel.replyToPostCommentId == "0")
                        ? postCommentModel.intId
                        : AppUtils.intVal(postCommentModel.replyToPostCommentId),
                  ),
                  child: Icon(
                    Icons.reply_all,
                    color: ThemeBloc.colorScheme.onPrimary,
                  ),
                ),
              )
          ],
        );
      } else {
        _postCommentsPageState.clearNotifier();
      }
    }

    return AppBar(
      title: Text(AppLocalizations.of(context)!.comments),
      leading: GestureDetector(onTap: AppNavigation.pop, child: const Icon(Icons.arrow_back)),
    );
  }

  Future<void> _loadPostcomments({bool latest = false, bool waitForFrame = false}) async {
    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_POST_COMMENT_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_POST_COMMENT_LOAD_BOTTOM,
      requestDataGenerator: () => {
        PostCommentTable.tableName: {PostCommentTable.parentPostId: _postModel.id},
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

    utilMixinSetState(() {
      activeContent.pagedModels<PostCommentModel>().forEach((postCommentId, postCommentModel) {
        if (postCommentModel.replyToPostCommentId == "0") {
          // list of post comments
          if (!_postCommentIds.contains(postCommentId)) {
            _postCommentIds.add(postCommentId);
          }
        }

        // join on users
        if (!_postCommentIdOnUserIdJoinMap.containsKey(postCommentId)) {
          _postCommentIdOnUserIdJoinMap
              .addAll({postCommentId: AppUtils.intVal(postCommentModel.ownerUserId)});
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _postCommentIds.isEmpty ? 0 : _postCommentIds.reduce(max),
        setBottomContentId: _postCommentIds.isEmpty ? 0 : _postCommentIds.reduce(min),
      );
    });
  }

  Future<void> _sumbitUserComment() async {
    if (_isPostcommentDeleteInProgress ||
        _isPostcommentSubmitInProgress ||
        _postCommentInputController.value.text.isEmpty) return;

    _focusNode.unfocus();

    var moveToOffset = (0) + 1;

    if (_postCommentsPageState.isReplyingToAPostcomment()) {
      var commentIndex = _postCommentIds.indexOf(_postCommentsPageState.replyingToActualPostcommentId);

      moveToOffset = (commentIndex * 3) + 2;
    }

    utilMixinSetState(() {
      _isPostCommentInputFocused = false;
      _postCommentSubmitLastError = '';
      _isPostcommentSubmitInProgress = true;

      _postCommentsScrollController.scrollTo(
        index: moveToOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });

    _submitPostcomment();
  }

  Future<void> _submitPostcomment() async {
    Map<String, dynamic> requestData = {
      PostCommentTable.tableName: {
        PostCommentTable.parentPostId: _postModel.intId,
        PostCommentTable.displayText: _postCommentInputController.value.text,
      },
    };

    if (_postCommentsPageState.isReplyingToAPostcomment()) {
      var replyingToCommentId = _postCommentsPageState.replyingToPostcommentId;

      var postCommentModel = activeContent.watch<PostCommentModel>(replyingToCommentId)!;

      var userModel = activeContent.watch<UserModel>(AppUtils.intVal(postCommentModel.ownerUserId))!;

      var displayText = '@${userModel.username} ${_postCommentInputController.value.text}';

      // add reply to field as comment is a reply to another comment
      requestData = {
        PostCommentTable.tableName: {
          PostCommentTable.parentPostId: _postModel.intId,
          PostCommentTable.replyToPostCommentId: _postCommentsPageState.replyingToActualPostcommentId,
          PostCommentTable.displayText: displayText,
        }
      };
    }

    var responseModel = await AppProvider.of(context).apiRepo.preparedRequest(
          requestType: REQ_TYPE_POST_COMMENT_ADD,
          requestData: requestData,
        );

    switch (responseModel.message) {
      case D_ERROR_POST_COMMENT_DISPLAY_TEXT_MAX_LEN_MSG:
        utilMixinSetState(() {
          _isPostcommentSubmitInProgress = false;
          _postCommentSubmitLastError = sprintf(
            AppLocalizations.of(context)!.fieldErrorPostCommentDisplayTextMaxLength,
            [AppSettings.getString(SETTING_MAX_LEN_POST_COMMENT_DISPLAY_TEXT)],
          );
        });
        break;

      case D_ERROR_POST_COMMENT_DISPLAY_TEXT_MIN_LEN_MSG:
        utilMixinSetState(() {
          _isPostcommentSubmitInProgress = false;
          _postCommentSubmitLastError = sprintf(
            AppLocalizations.of(context)!.fieldErrorPostCommentDisplayTextMinLength,
            [AppSettings.getString(SETTING_MIN_LEN_POST_COMMENT_DISPLAY_TEXT)],
          );
        });
        break;

      case SUCCESS_MSG:
        try {
          var postCommentModel = PostCommentModel.fromJson(responseModel.first(PostCommentTable.tableName));

          if (postCommentModel.isNotModel) throw Exception();

          activeContent.addOrUpdateModel<PostCommentModel>(postCommentModel);

          utilMixinSetState(() {
            _postCommentInputController.clear();
            _isPostcommentSubmitInProgress = false;

            if (_postCommentsPageState.isReplyingToAPostcomment()) {
              var replyToPostCommentId = AppUtils.intVal(postCommentModel.replyToPostCommentId);

              _postCommentsPageState.addPostcommentIdToIgnore(postCommentModel.intId);

              if (!_stuffedPostcommentReplyIds.containsKey(replyToPostCommentId)) {
                _stuffedPostcommentReplyIds.addAll({
                  replyToPostCommentId: [postCommentModel.intId]
                });
              } else {
                _stuffedPostcommentReplyIds[replyToPostCommentId]!.add(postCommentModel.intId);
              }
            } else {
              _postCommentIds.insert(0, postCommentModel.intId);
            }

            _postCommentIdOnUserIdJoinMap.addAll(
              {postCommentModel.intId: activeContent.authBloc.getCurrentUser.intId},
            );

            _postCommentsPageState.clearNotifier();
          });
        } catch (e) {
          AppLogger.exception(e);

          utilMixinSetState(() {
            _isPostcommentSubmitInProgress = false;
            _postCommentSubmitLastError = AppLocalizations.of(context)!.somethingWentWrongMessage;
          });
        }
        break;

      default:
        utilMixinSetState(() {
          _isPostcommentSubmitInProgress = false;
          _postCommentSubmitLastError = AppLocalizations.of(context)!.somethingWentWrongMessage;
        });
    }
  }

  Future<void> _deletePostcomment(PostCommentModel postCommentModel) async {
    if (_isPostcommentDeleteInProgress) return;

    utilMixinSetState(() {
      _isPostcommentDeleteInProgress = true;
    });

    var responseModel = await AppProvider.of(context).apiRepo.preparedRequest(
      requestType: REQ_TYPE_POST_COMMENT_REMOVE,
      requestData: {
        PostCommentTable.tableName: {PostCommentTable.id: postCommentModel.intId}
      },
    );

    if (SUCCESS_MSG != responseModel.message) {
      utilMixinSetState(() {
        activeContent.unlink<PostCommentModel>(postCommentModel.intId);
        _postCommentIds.remove(postCommentModel.intId);

        _isPostcommentDeleteInProgress = false;

        _postCommentsPageState.clearNotifier();
      });
    } else {
      contentMixinReloadPage();
    }
  }

  Widget _buildPostHeader() {
    var userModel =
        activeContent.watch<UserModel>(AppUtils.intVal(_postModel.ownerUserId)) ?? UserModel.none();
    if (userModel.isNotModel) {
      return AppLogger.fail('${userModel.runtimeType}(${_postModel.ownerUserId})');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: GestureDetector(
              onTap: () => PgUtils.openProfilePage(context, userModel.intId, utilMixinSetState),
              child: CachedNetworkImage(
                imageUrl: userModel.image,
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                    backgroundImage: imageProvider,
                    maxRadius: 16,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: ThemeBloc.textInterface.normalBlackH4TextStyle(),
                      children: [
                        TextSpan(
                          text: userModel.username,
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => PgUtils.openProfilePage(context, userModel.intId, utilMixinSetState),
                          style: ThemeBloc.textInterface.boldBlackH4TextStyle(),
                        ),
                        // space
                        const TextSpan(text: ' '),

                        ...utilMixinParsedTextSpan(_postModel.displayCaption),
                      ],
                    ),
                  ),
                  PgUtils.sizedBoxH(4),
                  ThemeBloc.textInterface.normalGreyH6Text(
                    text: AppTimeAgoParser.parseShort(_postModel.stampRegistration),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostcommentPlaceholder(UserModel userModel, String commentText, [bool isReply = false]) {
    return Container(
      color: ThemeBloc.colorScheme.secondary,
      padding: isReply
          ? const EdgeInsets.only(top: 10, bottom: 10, right: 16, left: 42)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: GestureDetector(
              onTap: () => PgUtils.openProfilePage(context, userModel.intId, utilMixinSetState),
              child: CachedNetworkImage(
                imageUrl: userModel.image,
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                    backgroundImage: imageProvider,
                    maxRadius: 16,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
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
                                    text: userModel.username,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => PgUtils.openProfilePage(
                                          context, userModel.intId, utilMixinSetState),
                                    style: ThemeBloc.textInterface.boldBlackH4TextStyle(),
                                  ),
                                  // space
                                  const TextSpan(text: ' '),

                                  // post display text
                                  TextSpan(
                                    text: (commentText.length > COMMENT_PLACEHOLDER_TEXT_WRAP_THRESHOLD)
                                        ? commentText.substring(0, COMMENT_PLACEHOLDER_TEXT_WRAP_THRESHOLD)
                                        : commentText,
                                    style: ThemeBloc.textInterface.normalBlackH4TextStyle(),
                                  ),
                                ],
                              ),
                            ),
                            PgUtils.sizedBoxH(4),
                            ThemeBloc.textInterface
                                .normalGreyH5Text(text: AppLocalizations.of(context)!.posting),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
