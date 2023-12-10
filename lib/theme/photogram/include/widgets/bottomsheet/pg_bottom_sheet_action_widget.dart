import 'package:flutter/material.dart';
import 'package:photogram/core/bloc/theme/theme_bloc.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/bottomsheet/pg_bottom_sheet_action.dart';

class PgBottomSheetActionWidget extends StatelessWidget {
  final PgBottomSheetAction action;

  const PgBottomSheetActionWidget(this.action, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _ignoring = false;

    if (null != action.isDivider) {
      return ThemeBloc.widgetInterface.divider();
    }

    TextStyle? _textStyle = ThemeBloc.getThemeData.textTheme.subtitle2;

    if (null != action.isHeader) {
      _ignoring = true;
      _textStyle = Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold);
    }

    if (null != action.isRed) {
      _textStyle = _textStyle!.copyWith(color: Theme.of(context).errorColor);
    }

    return IgnorePointer(
      child: InkWell(
        highlightColor: Colors.blue.withOpacity(0.1),
        splashColor: Colors.blue.withOpacity(0.3),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              if (action.iconData != null) Icon(action.iconData, size: 22),
              PgUtils.sizedBoxW(16),
              Text(
                action.title ?? '',
                style: _textStyle,
              )
            ],
          ),
        ),
        onTap: action.onTap,
      ),
      ignoring: _ignoring,
    );
  }
}
