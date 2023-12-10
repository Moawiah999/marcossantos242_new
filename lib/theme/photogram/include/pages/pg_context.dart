import 'package:flutter/material.dart';

import 'package:photogram/theme/photogram/include/widgets/bottomsheet/pg_bottom_sheet_action.dart';
import 'package:photogram/theme/photogram/include/widgets/bottomsheet/pg_bottom_sheet_scrollable.dart';

extension PgThemeContext on BuildContext {
  Future<PgBottomSheetAction?> showBottomSheet(List<PgBottomSheetAction> actions) {
    return showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return PgBottomSheetScrollable(
              actions: actions,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }
}
