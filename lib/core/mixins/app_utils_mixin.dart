import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';

mixin AppUtilsMixin<T extends StatefulWidget> on State<T> {
  void utilMixinSetState([Function? callback]) => setState(() {
        if (null != callback) {
          callback();
        }
      });

  void utilMixinPostSetState([Function? callback]) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        if (null != callback) {
          callback();
        }
      });
    });
  }

  void utilMixinPostFrame([Function? callback]) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (null != callback) {
        callback();
      }
    });
  }

  void utilMixinSomethingWentWrongMessage([bool waitForFrame = false]) {
    ThemeBloc.actionInterface.showMessageInsidePopUp(
      waitForFrame: waitForFrame,
      context: context,
      message: AppLocalizations.of(context)!.somethingWentWrongMessage,
    );
  }

  void utilMixinShowMessage(String message, [bool waitForFrame = false]) {
    ThemeBloc.actionInterface.showMessageInsidePopUp(
      waitForFrame: waitForFrame,
      context: context,
      message: message,
    );
  }

  List<TextSpan> utilMixinParsedTextSpan(String textToPrint, [bool collapsed = false]) {
    var textSpans = <TextSpan>[];

    var regExp = RegExp(REGEXP_HASHTAG);

    if (!regExp.hasMatch(textToPrint) || textToPrint.isEmpty) {
      return [TextSpan(text: textToPrint, style: ThemeBloc.textInterface.normalBlackH4TextStyle())];
    }

    var texts = textToPrint.split(regExp);
    var hashtags = regExp.allMatches(textToPrint).toList();

    for (final text in texts) {
      textSpans.add(TextSpan(text: text, style: ThemeBloc.textInterface.normalBlackH4TextStyle()));

      if (hashtags.isNotEmpty) {
        var match = hashtags.removeAt(0);
        var hashtag = match.input.substring(match.start + 1, match.end);

        textSpans.add(
          TextSpan(
            text: "#$hashtag",
            style: ThemeBloc.textInterface.normalHrefH4TextStyle(),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (collapsed && textToPrint.length == match.end) return;
                PgUtils.openHashtagPage(context, 0, hashtag, utilMixinSetState);
              },
          ),
        );
      }
    }

    return textSpans;
  }
}
