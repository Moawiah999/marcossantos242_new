import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photogram/import/core.dart';
import 'package:tuple/tuple.dart';

class PgBottomNavigationItem extends StatefulWidget {
  late final Tuple2<String, String> _icon;
  late final VoidCallback? _onTapCallback;
  late final bool _isSelected;
  final num iconSize;

  PgBottomNavigationItem({
    Key? key,
    required int index,
    required int activeIndex,
    required VoidCallback onPress,
    this.iconSize = 20,
  }) : super(key: key) {
    _icon = AppIcons.bottomTabIcons[index];
    _isSelected = index == activeIndex;
    _onTapCallback = onPress;
  }

  @override
  _PgBottomNavigationItemState createState() => _PgBottomNavigationItemState();
}

class _PgBottomNavigationItemState extends State<PgBottomNavigationItem>
    with AppActiveContentMixin, AppUtilsMixin {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkResponse(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: SvgPicture.asset(
            widget._isSelected ? widget._icon.item2 : widget._icon.item1,
            height: widget.iconSize.toDouble(),
            width: widget.iconSize.toDouble(),
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        onTap: widget._onTapCallback,
      ),
    );
  }
}
