import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';

mixin AppActiveContentMixin<T extends StatefulWidget> on State<T> {
  late final AppActiveContent activeContent;

  /// available for override to widgets

  void onLoadEvent() => 'nop';
  void onDisposeEvent() => 'nop';
  bool? onReloadBeforeEvent() => null;
  void onReloadAfterEvent() => 'nop';

  @override
  void initState() {
    super.initState();
    activeContent = AppActiveContent(context);
    onLoadEvent();
  }

  @override
  void dispose() {
    onDisposeEvent();
    activeContent.dispose();
    super.dispose();
  }

  Future<void> contentMixinReloadPage() async {
    var isReloadable = onReloadBeforeEvent();

    if (null != isReloadable && false == isReloadable) return;

    setState(() {});

    onReloadAfterEvent();
  }
}
