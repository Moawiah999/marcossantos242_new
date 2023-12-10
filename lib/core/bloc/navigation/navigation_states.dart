import 'package:flutter/widgets.dart';

abstract class NavigationState {
  final BuildContext context;

  NavigationState(this.context);
}

/// navigator state changed
///
class NavigationStateNavigatorStateUpdated extends NavigationState {
  GlobalKey<NavigatorState> newNavigatorState;

  NavigationStateNavigatorStateUpdated(BuildContext context, this.newNavigatorState) : super(context);
}
