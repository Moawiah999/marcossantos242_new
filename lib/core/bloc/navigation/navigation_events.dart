import 'package:flutter/material.dart';

abstract class NavigationEvent {
  final BuildContext context;

  NavigationEvent(this.context);
}

/// Try setting theme mode from local repo(if exists)
///
class NavigatorEventChangeNavigatorState extends NavigationEvent {
  GlobalKey<NavigatorState> navigatorStateToSet;

  NavigatorEventChangeNavigatorState(BuildContext context, {required this.navigatorStateToSet}) : super(context);
}
