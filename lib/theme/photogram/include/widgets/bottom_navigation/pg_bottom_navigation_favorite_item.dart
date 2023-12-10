import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:tuple/tuple.dart';

class PgBottomNavigationFavoriteItem extends StatefulWidget {
  late final Tuple2<String, String> _icon;
  late final VoidCallback? _onTapCallback;
  late final bool _isSelected;

  PgBottomNavigationFavoriteItem({
    Key? key,
    required int index,
    required int activeIndex,
    required VoidCallback onPress,
  }) : super(key: key) {
    _icon = AppIcons.bottomTabIcons[index];
    _isSelected = index == activeIndex;
    _onTapCallback = onPress;
  }

  @override
  _PgBottomNavigationFavoriteItemState createState() => _PgBottomNavigationFavoriteItemState();
}

class _PgBottomNavigationFavoriteItemState extends State<PgBottomNavigationFavoriteItem> with AppUtilsMixin {
  var _previousNotificationDTO =
      NotificationsCountDTO(likeCount: "0", commentCount: "0", followCount: "0", otherCount: "0");

  late Timer _ballonAutoHideTimer;
  var _isBallonVisible = true;

  @override
  void initState() {
    super.initState();
    _ballonAutoHideTimer = Timer(const Duration(seconds: 1), () {});
  }

  @override
  void dispose() {
    if (_ballonAutoHideTimer.isActive) {
      _ballonAutoHideTimer.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NotificationsState>(
        stream: NotificationsBloc.of(context).stream,
        builder: (context, snapshot) {
          var hasCounts = snapshot.hasData && snapshot.data!.hasCounts;

          // ballon autohider
          if (hasCounts) {
            // if changed only then push the updated state
            if (_previousNotificationDTO.likeCount != snapshot.data!.notificationsCountDTO.likeCount ||
                _previousNotificationDTO.commentCount != snapshot.data!.notificationsCountDTO.commentCount ||
                _previousNotificationDTO.followCount != snapshot.data!.notificationsCountDTO.followCount ||
                _previousNotificationDTO.otherCount != snapshot.data!.notificationsCountDTO.otherCount) {
              // change previous first
              _previousNotificationDTO = snapshot.data!.notificationsCountDTO;

              // show ballon
              _isBallonVisible = true;

              // setup auto hide logic
              if (_ballonAutoHideTimer.isActive) {
                _ballonAutoHideTimer.cancel();
              }
              _ballonAutoHideTimer = Timer(const Duration(seconds: 15), () {
                utilMixinSetState(() {
                  _isBallonVisible = false;
                });
              });
            }
          }

          return Expanded(
            child: InkResponse(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        widget._isSelected ? widget._icon.item2 : widget._icon.item1,
                        height: 22,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    if (hasCounts)
                      Align(
                        alignment: Alignment.topCenter,
                        child: SimpleTooltip(
                          tooltipTap: () => PgUtils.openActivityPage(utilMixinSetState),
                          show: _isBallonVisible,
                          borderWidth: 0,
                          borderRadius: 6,
                          arrowLength: 6,
                          arrowBaseWidth: 12,
                          child: const Icon(Icons.circle_sharp, size: 8, color: Colors.red),
                          ballonPadding: EdgeInsets.zero,
                          animationDuration: const Duration(milliseconds: 400),
                          tooltipDirection: TooltipDirection.up,
                          backgroundColor: Colors.red,
                          content: _buildNotificationsBallon(snapshot.data!),
                        ),
                      ),
                  ],
                ),
              ),
              onTap: widget._onTapCallback,
            ),
          );
        });
  }

  Widget _buildNotificationsBallon(NotificationsState state) {
    var hasLikes = "0" != state.notificationsCountDTO.likeCount;
    var hasComments = "0" != state.notificationsCountDTO.commentCount;
    var hasFollows = "0" != state.notificationsCountDTO.followCount;
    var hasOthers = "0" != state.notificationsCountDTO.otherCount;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (hasLikes)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                const Icon(Icons.favorite, size: 20, color: Colors.white),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    state.notificationsCountDTO.likeCount,
                    style: ThemeBloc.textInterface
                        .normalBlackH6TextStyle()
                        .copyWith(inherit: false, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        if (hasComments)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.comment,
                  size: 20,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    state.notificationsCountDTO.commentCount,
                    style: ThemeBloc.textInterface
                        .normalBlackH6TextStyle()
                        .copyWith(inherit: false, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              const Icon(Icons.person, size: 20, color: Colors.white),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  state.notificationsCountDTO.followCount,
                  style: ThemeBloc.textInterface
                      .normalBlackH6TextStyle()
                      .copyWith(inherit: false, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        if (hasOthers)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                const Icon(Icons.notification_important, size: 20, color: Colors.white),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    state.notificationsCountDTO.otherCount,
                    style: ThemeBloc.textInterface
                        .normalBlackH6TextStyle()
                        .copyWith(inherit: false, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
