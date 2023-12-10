import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
/*
|--------------------------------------------------------------------------
| bloc:
|--------------------------------------------------------------------------
*/

class NavigationBloc {
  static NavigationBloc of(BuildContext context) => AppProvider.of(context).navigation;

  /*
  |--------------------------------------------------------------------------
  | stream controllers:
  |--------------------------------------------------------------------------
  */
  final _stateController = StreamController<NavigationState>.broadcast();

  final _eventController = StreamController<NavigationEvent>();

  /*
  |--------------------------------------------------------------------------
  | exposed stream
  |--------------------------------------------------------------------------
  */

  Stream<NavigationState> get stream => _stateController.stream;

  late int _currentBottomNavIndex;
  int get currentBottomNavIndex => _currentBottomNavIndex;

  /*
  |--------------------------------------------------------------------------
  | constructor:
  |--------------------------------------------------------------------------
  */

  NavigationBloc() {
    AppLogger.blockInfo("NavigationBloc: Init");

    _setNavigatorState(DEFAULT_NAVIGATOR_STATE);

    _eventController.stream.listen(_handleEvent);
  }

  /*
  |--------------------------------------------------------------------------
  | push events [exposed]:
  |--------------------------------------------------------------------------
  */

  void pushEvent(NavigationEvent event) {
    AppLogger.blockInfo("NavigationBloc [UI]: Event ~> ${event.runtimeType}");
    _eventController.sink.add(event);
  }

  /*
  |--------------------------------------------------------------------------
  | push state:
  |--------------------------------------------------------------------------
  */

  void _pushState(NavigationState state) {
    AppLogger.blockInfo("NavigationBloc: State ~> ${state.runtimeType}");

    // do internal state changes (if any)
    switch (state.runtimeType) {
      case NavigationStateNavigatorStateUpdated:
        _setNavigatorState((state as NavigationStateNavigatorStateUpdated).newNavigatorState);
        break;
    }

    // push the state to listeners
    _stateController.sink.add(state);
  }

  /*
  |--------------------------------------------------------------------------
  | handle events:
  |--------------------------------------------------------------------------
  */

  void _handleEvent(NavigationEvent event) {
    AppLogger.blockInfo("NavigationBloc: Handling event <~ ${event.runtimeType}");

    switch (event.runtimeType) {
      case NavigatorEventChangeNavigatorState:
        return _navigatorEventChangeNavigatorState(event as NavigatorEventChangeNavigatorState);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | update navigator state
  |--------------------------------------------------------------------------
  */

  void _navigatorEventChangeNavigatorState(NavigatorEventChangeNavigatorState event) async {
    try {
      _pushState(NavigationStateNavigatorStateUpdated(event.context, event.navigatorStateToSet));
    } catch (e) {
      AppLogger.exception(e);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | update internal state
  |--------------------------------------------------------------------------
  */

  void _setNavigatorState(GlobalKey<NavigatorState> navigatorState) {
    // if feeds page
    if (navigatorState == AppNavigation.feedsPageNavigator) {
      _currentBottomNavIndex = 0;
      AppNavigation.setAppNavigator = AppNavigation.feedsPageNavigator;

      // search page
    } else if (navigatorState == AppNavigation.searchPageNavigator) {
      _currentBottomNavIndex = 1;
      AppNavigation.setAppNavigator = AppNavigation.searchPageNavigator;

      // favorite page
    } else if (navigatorState == AppNavigation.activityPageNavigator) {
      _currentBottomNavIndex = 3;
      AppNavigation.setAppNavigator = AppNavigation.activityPageNavigator;

      // profile page
    } else if (navigatorState == AppNavigation.profilePageNavigator) {
      _currentBottomNavIndex = 4;
      AppNavigation.setAppNavigator = AppNavigation.profilePageNavigator;
    }
  }

  /*
  |--------------------------------------------------------------------------
  | dispose streams [exposed]:
  |--------------------------------------------------------------------------
  */

  void dispose() {
    _eventController.close();
    _stateController.close();

    AppLogger.blockInfo("NavigationBloc: Dispose");
  }
}
