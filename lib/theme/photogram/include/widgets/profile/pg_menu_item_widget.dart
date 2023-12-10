import 'package:flutter/material.dart';
import 'package:photogram/core/bloc/theme/theme_bloc.dart';

class PgMenuItemWidget extends StatelessWidget {
  final String title;
  final String content;
  final bool isRow;

  const PgMenuItemWidget({
    Key? key,
    required this.title,
    required this.content,
    this.isRow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isRow) {
      return RichText(
        text: TextSpan(children: [
          TextSpan(text: title, style: ThemeBloc.textInterface.boldBlackH2TextStyle()),
          const TextSpan(text: '   '),
          TextSpan(text: content, style: ThemeBloc.textInterface.normalBlackH4TextStyle()),
        ]),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ThemeBloc.textInterface.boldBlackH2Text(text: title),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: ThemeBloc.textInterface.normalBlackH4Text(text: content),
        )
      ],
    );
  }
}
