import 'package:flutter/material.dart';
import 'package:photogram/theme/photogram/include/widgets/bottomsheet/pg_bottom_sheet_action.dart';
import 'package:photogram/theme/photogram/include/widgets/bottomsheet/pg_bottom_sheet_action_widget.dart';

class PgBottomSheetScrollable extends StatelessWidget {
  final List<PgBottomSheetAction> actions;
  final ScrollController scrollController;

  const PgBottomSheetScrollable({
    Key? key,
    required this.actions,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            width: 64,
            height: 8,
            decoration: ShapeDecoration(
                shape: const StadiumBorder(), color: Theme.of(context).dialogBackgroundColor),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: ShapeDecoration(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                color: Theme.of(context).dialogBackgroundColor),
            child: Material(
              color: Theme.of(context).dialogBackgroundColor,
              child: SafeArea(
                child: ListView(
                  shrinkWrap: true,
                  controller: scrollController,
                  children: actions.map((action) => PgBottomSheetActionWidget(action)).toList(),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
