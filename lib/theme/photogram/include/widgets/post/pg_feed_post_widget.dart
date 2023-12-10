import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/theme/pg_exclusive.dart';
import 'package:photogram/theme/photogram/include/pages/post/pg_post_content_images_view.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/bottomsheet/pg_add_to_collection_bottomsheet.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:sprintf/sprintf.dart';

class PgFeedPostWidget extends StatefulWidget {
  final int postId;
  final sliderIndicatorMaxItems = 5;
  final bool showFollowButton;

  const PgFeedPostWidget({
    Key? key,
    this.showFollowButton = false,
    required this.postId,
  }) : super(key: key);

  @override
  State<PgFeedPostWidget> createState() => _PgFeedPostWidgetState();
}

class _PgFeedPostWidgetState extends State<PgFeedPostWidget>
    with AppActiveContentMixin, AppPostMixin, AppUserMixin, AppUtilsMixin {
  late UserModel _userModel;
  late PostModel _postModel;

  final flareControls = FlareControls();

  final _visibleItemsInIndicator = <int>[];
  final _smallItemsInIndicator = <int>[];

  var _isIndicatorMovingForward = false;
  var _isReadingMore = false;

  var _currentContentIndex = 0;
  var _previousContentIndex = 0;
  var _contentSlideForwardCount = 0;

  // post meta visible
  var _postMetaContentVisible = true;
  var _postContentMetaUserTagsVisible = false;
  late Timer _postInActivityTimer;

  @override
  void onLoadEvent() {
    _postModel = activeContent.watch<PostModel>(widget.postId) ?? PostModel.none();
    var userIdInt = AppUtils.intVal(_postModel.ownerUserId);

    _userModel = activeContent.watch<UserModel>(userIdInt) ?? UserModel.none();

    _postInActivityTimer = Timer(const Duration(seconds: 10), _togglePostMetaContentVisibility);
  }

  @override
  void onDisposeEvent() {
    if (_postInActivityTimer.isActive) {
      _postInActivityTimer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_postModel.isNotModel) {
      return AppLogger.fail('${_postModel.runtimeType}(${widget.postId})');
    }

    if (_userModel.isNotModel) {
      return AppLogger.fail('${_userModel.runtimeType}');
    }

    if (!_postModel.isVisible) {
      return AppUtils.nothing();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildUserHeader(),
        _buildPostContent(),
        _buildPostOptions(),
        _buildPostInfoSecion(),
        PgUtils.sizedBoxH(20),
      ],
    );
  }

  Widget _buildUserHeader() {
    return ListTile(
      dense: true,
      horizontalTitleGap: 5,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: GestureDetector(
        onTap: _openPostOwnerProfilePage,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xff7934E6),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              width: 40,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  maxRadius: 18,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: CachedNetworkImageProvider(
                    _userModel.image,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          _buildUserTitlePart(),
          const SizedBox(width: 8),
          if (_userModel.cacheFollowersCount >= 100) ...[
            Image.asset('assets/png/carraca.png', height: 16),
          ],
        ],
      ),
      subtitle: _postModel.displayLocation.isNotEmpty
          ? ThemeBloc.textInterface.normalBlackH5Text(text: _postModel.displayLocation)
          : null,
      trailing: _popUpMenu(),
    );
  }

  Widget _buildUserTitlePart() {
    if (widget.showFollowButton && !_userModel.isFollowedByCurrentUser) {
      var textSpans = [
        WidgetSpan(
          child: Row(
            children: [
              GestureDetector(
                onTap: _openPostOwnerProfilePage,
                child: ThemeBloc.textInterface.boldBlackH4Text(
                  text: _userModel.name,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 30,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    side: BorderSide(
                      color: ThemeBloc.colorScheme.onBackground,
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  onPressed: () => userMixinFollowUser(_userModel, true),
                  child: Text(
                    AppLocalizations.of(context)!.follow,
                    style: TextStyle(
                      color: ThemeBloc.colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ];

      return RichText(text: TextSpan(children: textSpans));
    }

    return GestureDetector(
      onTap: _openPostOwnerProfilePage,
      child: ThemeBloc.textInterface.boldBlackH4Text(text: _userModel.name),
    );
  }

  Widget _buildPostContent() {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onDoubleTap: () {
        flareControls.play("like");

        if (_postModel.isNotLiked) {
          postMixinLikePost(_postModel, true);
        }
      },
      onLongPress: () {
        AppNavigation.push(
          context,
          MaterialPageRoute(
            builder: (_) => PgPostContentImagesView(
              postId: _postModel.intId,
              initialIndex: _currentContentIndex,
            ),
          ),
          () {},
        );
      },
      onTap: () {
        if (_postModel.displayContent.items[_currentContentIndex].displayUserTagsOnItemDTO.isNotEmpty) {
          utilMixinSetState(() {
            _postContentMetaUserTagsVisible = _postContentMetaUserTagsVisible ? false : true;
          });
        }
      },
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: _buildPostContentSection(),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: FlareActor('assets/flare/postlike.flr', animation: 'idle', controller: flareControls),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostOptions() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPostActions(),
          if (_postModel.displayContent.length > 1) _buildCarouselIndicator(),
          _buildPostExtraOptions(),
        ],
      ),
    );
  }

  Widget _buildPostActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (_postModel.isLiked)
            ? GestureDetector(
                onTap: () => postMixinLikePost(_postModel, false),
                child: SvgPicture.asset(
                  AppIcons.bottomNavFavoriteActive,
                  color: Colors.red,
                  width: 25,
                  height: 25,
                ),
              )
            : GestureDetector(
                onTap: () => postMixinLikePost(_postModel, true),
                child: SvgPicture.asset(
                  AppIcons.bottomNavFavorite,
                  color: ThemeBloc.colorScheme.onBackground,
                  width: 25,
                  height: 25,
                ),
              ),
        PgUtils.sizedBoxW(20),
        GestureDetector(
          onTap: _openPostcommentsPage,
          child: SvgPicture.asset('assets/svg/ic_comment.svg',
              color: ThemeBloc.colorScheme.onBackground, width: 25),
        )
      ],
    );
  }

  Widget _buildPostExtraOptions() {
    // save to collection button
    return Row(
      children: [
        if (_userModel.cacheFollowersCount >= 100)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PgExclusive(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff7934E6),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/coroa.svg',
                      height: 10,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Exclusivo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(width: 6),
        GestureDetector(
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return DraggableScrollableSheet(
                  expand: false,
                  builder: (context, scrollController) {
                    return PgAddToCollectionBottomSheet(postId: _postModel.intId);
                  },
                );
              },
            ).whenComplete(() {
              utilMixinSetState();
            });
          },
          onTap: () =>
              _postModel.isSaved ? postMixinSavePost(_postModel, false) : postMixinSavePost(_postModel, true),
          child: _postModel.isSaved
              ? const Icon(
                  Icons.bookmark,
                  size: 30,
                )
              : const Icon(
                  Icons.bookmark_outline,
                  size: 30,
                ),
        ),
      ],
    );
  }

  Widget _buildPostContentSection() {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          maintainState: false,
          builder: (context) {
            return Stack(
              children: [
                _buildCarousel(),
                _buildPostSliderCountIndicator(),
                ..._buildPostTagSectionItems(),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCarousel() {
    return Positioned.fill(
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 1,
          initialPage: 0,
          viewportFraction: 1,
          enableInfiniteScroll: false,
          scrollPhysics: _postContentMetaUserTagsVisible ? const NeverScrollableScrollPhysics() : null,
          onPageChanged: (index, reason) {
            utilMixinSetState(() {
              // get the difference first
              var offsetDifference = index - _currentContentIndex;

              // update the state
              _previousContentIndex = _currentContentIndex;
              _currentContentIndex = index;

              // if we're moving forward but user moved to back
              if (_isIndicatorMovingForward && offsetDifference <= 0) {
                _contentSlideForwardCount--;
              }
              // if we're moving backward but user moved to forward
              else if (!_isIndicatorMovingForward && offsetDifference > 0) {
                _contentSlideForwardCount++;
              }

              // if can be set to moving forward
              if (_contentSlideForwardCount == widget.sliderIndicatorMaxItems - 1) {
                _isIndicatorMovingForward = true;
                // _justChangedDirection = true;

                // if can be set to moving backward
              } else if (_contentSlideForwardCount == 0) {
                _isIndicatorMovingForward = false;
                // _justChangedDirection = true;
              } else {
                // _justChangedDirection = false;
              }

              _togglePostMetaContentVisibility(true);
            });
          },
        ),
        items: _postModel.displayContent.items.map((item) {
          return AspectRatio(
            aspectRatio: 1,
            child: SizedBox(
              width: double.infinity,
              child: CachedNetworkImage(
                placeholder: (_, __) => Container(color: Colors.grey[300]),
                imageUrl: item.displayItemDTO.urlCompressed,
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPostSliderCountIndicator() {
    if (_postModel.displayContent.length > 1) {
      return Positioned(
        top: 10,
        right: 10,
        child: Opacity(
          opacity: _postMetaContentVisible ? 0.7 : 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            decoration: BoxDecoration(
              color: ThemeBloc.colorScheme.onBackground,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              '${_currentContentIndex + 1}/${_postModel.displayContent.length}',
              style: ThemeBloc.textInterface.normalThemeH5TextStyle().copyWith(
                    color: ThemeBloc.colorScheme.background,
                    letterSpacing: 2,
                  ),
            ),
          ),
        ),
      );
    }

    return AppUtils.nothing();
  }

  List<Widget> _buildPostTagSectionItems() {
    var itemsOnStack = <Widget>[];

    if (_postModel.displayContent.items[_currentContentIndex].displayUserTagsOnItemDTO.isNotEmpty) {
      itemsOnStack.add(
        Positioned(
          bottom: 10,
          left: 10,
          child: Opacity(
            opacity: _postMetaContentVisible || _postContentMetaUserTagsVisible ? 0.7 : 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: ThemeBloc.colorScheme.onBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 14,
                color: ThemeBloc.colorScheme.background,
              ),
            ),
          ),
        ),
      );

      for (var userTag
          in _postModel.displayContent.items[_currentContentIndex].displayUserTagsOnItemDTO.tags) {
        itemsOnStack.add(
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double offsetTop = (userTag.offsetTop / 100);
                double offsetLeft = (userTag.offsetLeft / 100);

                if (offsetLeft > .98) {
                  offsetLeft = 0.97;
                }

                if (offsetLeft < .01) {
                  offsetLeft = 0.02;
                }

                bool isUp = offsetLeft > .35 && offsetLeft < .65;

                return Align(
                  alignment: Alignment(-1.0 + offsetLeft * 2, -1.0 + offsetTop * 2),
                  child: SimpleTooltip(
                    tooltipTap: () => PgUtils.openProfilePage(context, userTag.userId, utilMixinSetState),
                    show: _postContentMetaUserTagsVisible,
                    borderWidth: 0,
                    borderRadius: 6,
                    arrowLength: isUp ? 4 : 10,
                    arrowBaseWidth: 8,
                    child: const SizedBox.shrink(),
                    ballonPadding: EdgeInsets.zero,
                    animationDuration: const Duration(milliseconds: 400),
                    tooltipDirection: offsetLeft > .65
                        ? TooltipDirection.left
                        : (offsetLeft < .35 ? TooltipDirection.right : TooltipDirection.up),
                    backgroundColor: ThemeBloc.colorScheme.onBackground.withOpacity(0.75),
                    content: Text(
                      userTag.username,
                      style: ThemeBloc.textInterface
                          .normalHrefH6TextStyle()
                          .copyWith(color: ThemeBloc.colorScheme.background),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    }

    return itemsOnStack;
  }

  Widget _buildCarouselIndicator() {
    var totalItems = _postModel.displayContent.length;

    var dots = <Widget>[];
    var needsIntialization = _visibleItemsInIndicator.isEmpty;
    var isMovedForward = _currentContentIndex - _previousContentIndex > 0;

    if (_isIndicatorMovingForward &&
        isMovedForward &&
        _smallItemsInIndicator.contains(_currentContentIndex)) {
      _visibleItemsInIndicator.add(_currentContentIndex + 1);
      _visibleItemsInIndicator.remove(_currentContentIndex - widget.sliderIndicatorMaxItems - 1);

      _smallItemsInIndicator.remove(_currentContentIndex - widget.sliderIndicatorMaxItems - 1);

      _smallItemsInIndicator.add(_currentContentIndex - widget.sliderIndicatorMaxItems);
      _smallItemsInIndicator.add(_currentContentIndex + 1);
      _smallItemsInIndicator.remove(_currentContentIndex);
    } else if (!_isIndicatorMovingForward &&
        !isMovedForward &&
        _smallItemsInIndicator.contains(_currentContentIndex)) {
      _visibleItemsInIndicator.add(_currentContentIndex - 1);
      _visibleItemsInIndicator.remove(_currentContentIndex + widget.sliderIndicatorMaxItems + 1);

      _smallItemsInIndicator.remove(_currentContentIndex + widget.sliderIndicatorMaxItems + 1);

      _smallItemsInIndicator.add(_currentContentIndex + widget.sliderIndicatorMaxItems);
      _smallItemsInIndicator.add(_currentContentIndex - 1);
      _smallItemsInIndicator.remove(_currentContentIndex);
    }

    for (var index = 0; index < totalItems; index++) {
      var offsetFromActiveItem = index - _currentContentIndex;

      // initalization
      if (needsIntialization) {
        if (offsetFromActiveItem >= 0 && offsetFromActiveItem <= widget.sliderIndicatorMaxItems) {
          if (index == widget.sliderIndicatorMaxItems) {
            _smallItemsInIndicator.add(index);
          }
          _visibleItemsInIndicator.add(index);
        }
      }

      if (_visibleItemsInIndicator.contains(index)) {
        dots.add(
          Container(
            width: (_smallItemsInIndicator.contains(index)) ? 4.0 : (offsetFromActiveItem == 0 ? 9.0 : 7.0),
            height: (_smallItemsInIndicator.contains(index)) ? 4.0 : (offsetFromActiveItem == 0 ? 9.0 : 7.0),
            margin: const EdgeInsets.fromLTRB(2, 0, 2, 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: offsetFromActiveItem == 0
                  ? ThemeBloc.colorScheme.primary
                  : ThemeBloc.colorScheme.onBackground.withOpacity(0.2),
            ),
          ),
        );
      }
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: dots);
  }

  Widget _buildPostInfoSecion() {
    var totalComments = _postModel.cacheCommentsCount;

    var authedUser = activeContent.authBloc.getCurrentUser;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _openPostlikesPage,
            child: ThemeBloc.textInterface.boldBlackH4Text(
              text: sprintf(
                AppLocalizations.of(context)!.nLikes,
                [AppUtils.compactNumber(_postModel.cacheLikesCount)],
              ),
            ),
          ),
          PgUtils.sizedBoxH(10),
          RichText(
            text: TextSpan(
              children: [
                // username
                TextSpan(
                  text: _userModel.username,
                  recognizer: TapGestureRecognizer()..onTap = _openPostOwnerProfilePage,
                  style: ThemeBloc.textInterface.boldBlackH4TextStyle(),
                ),
                // space
                const TextSpan(text: ' '),

                // post display text
                ..._buildPostDisplayCaption(),

                // space
                const TextSpan(text: ' '),

                // show more utility
                if (_postModel.displayCaption.length > 100 && !_isReadingMore)
                  TextSpan(
                    text: AppLocalizations.of(context)!.showMore,
                    recognizer: TapGestureRecognizer()..onTap = () => readMore(true),
                    style: ThemeBloc.textInterface.normalGreyH4TextStyle(),
                  )
                else if (_postModel.displayCaption.length > 100)
                  TextSpan(
                    text: AppLocalizations.of(context)!.showLess,
                    recognizer: TapGestureRecognizer()..onTap = () => readMore(false),
                    style: ThemeBloc.textInterface.normalGreyH4TextStyle(),
                  ),
              ],
            ),
          ),

          // view more comments
          if (totalComments > 0)
            GestureDetector(
              onTap: () => _openPostcommentsPage(false),
              child: Container(
                child: ThemeBloc.textInterface.normalGreyH4Text(
                  text: sprintf(AppLocalizations.of(context)!.viewAllNComments, [totalComments]),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4),
              ),
            ),

          // add user dummy comment box
          if (authedUser.isModel || totalComments > 0 && totalComments < 10)
            GestureDetector(
              onTap: _openPostcommentsPage,
              child: ListTile(
                dense: true,
                minLeadingWidth: 0,
                contentPadding: EdgeInsets.zero,
                title:
                    ThemeBloc.textInterface.normalGreyH6Text(text: AppLocalizations.of(context)!.addAComment),
                leading: CircleAvatar(
                  maxRadius: 15,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: CachedNetworkImageProvider(
                    authedUser.image,
                  ),
                ),
              ),
            ),
          // view more comments
          Container(
            child: ThemeBloc.textInterface.normalGreyH6Text(
              text: AppTimeAgoParser.parse(_postModel.stampRegistration),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildPostDisplayCaption() {
    var isCollapsed = (_postModel.displayCaption.length > 100 && !_isReadingMore);

    var textToPrint = isCollapsed ? _postModel.displayCaption.substring(0, 100) : _postModel.displayCaption;

    return utilMixinParsedTextSpan(textToPrint, isCollapsed);
  }

  bool readMore([bool? readMore]) {
    if (readMore != null) {
      utilMixinSetState(() {
        _isReadingMore = readMore;
      });
    }

    return _isReadingMore;
  }

  Widget _popUpMenu() {
    return GestureDetector(
      child: Icon(Icons.more_vert, color: ThemeBloc.getThemeData.iconTheme.color, size: 22),
      onTap: () {
        return PgUtils.showPopUpWithOptions(
          context: context,
          options: _buildPopUpOptionsForPost(),
        );
      },
    );
  }

  List<Widget> _buildPopUpOptionsForPost() {
    var options = [
      PgUtils.popUpOption(
        buildContext: context,
        onTap: _openPostOwnerProfilePage,
        content: AppLocalizations.of(context)!.viewUser,
      ),
    ];

    if (_userModel.isLoggedIn) {
      options.add(
        PgUtils.popUpOption(
          buildContext: context,
          isDanger: true,
          onTap: () => postMixinDeletePost(_postModel),
          content: AppLocalizations.of(context)!.deletePost,
        ),
      );
    }

    return options;
  }

  void _openPostOwnerProfilePage() => PgUtils.openProfilePage(context, _userModel.intId, utilMixinSetState);

  void _openPostlikesPage() => PgUtils.openPostlikesPage(context, widget.postId, utilMixinSetState);

  void _openPostcommentsPage([bool focus = true]) => PgUtils.openPostcommentsPage(
        context: context,
        postId: widget.postId,
        focus: focus,
        refreshCallback: utilMixinSetState,
      );

  void _togglePostMetaContentVisibility([bool show = false]) {
    utilMixinSetState(() {
      _postMetaContentVisible = show;

      if (show) {
        if (_postInActivityTimer.isActive) {
          _postInActivityTimer.cancel();
        }

        _postInActivityTimer = Timer(const Duration(seconds: 6), _togglePostMetaContentVisibility);
      }
    });
  }
}
