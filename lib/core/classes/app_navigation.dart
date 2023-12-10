import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';

class AppNavigation {
  /*
  |--------------------------------------------------------------------------
  | meta data:
  |--------------------------------------------------------------------------
  */

  static final feedsPageNavigator = GlobalKey<NavigatorState>();
  static final searchPageNavigator = GlobalKey<NavigatorState>();
  static final activityPageNavigator = GlobalKey<NavigatorState>();
  static final profilePageNavigator = GlobalKey<NavigatorState>();

  static final mainNavigators = [
    feedsPageNavigator,
    searchPageNavigator,
    activityPageNavigator,
    profilePageNavigator,
  ];

  static final _pageStacks = <GlobalKey<NavigatorState>, List<String>>{};

  static var _currentPageOnActiveStack = '';

  /*
  |--------------------------------------------------------------------------
  | navigator data:
  |--------------------------------------------------------------------------
  */

  static BuildContext? contextWithProvider;

  static GlobalKey<NavigatorState>? _mainNavigator;

  static final childNavigators = <GlobalKey<NavigatorState>, NavigatorState?>{};

  static final navigatorSwitchHistory = <GlobalKey<NavigatorState>?>[];

  /*
  |--------------------------------------------------------------------------
  | getters:
  |--------------------------------------------------------------------------
  */

  static GlobalKey<NavigatorState>? get getAppNavigator => _mainNavigator;

  static NavigatorState? get getChildNavigator {
    if (childNavigators.containsKey(_mainNavigator)) {
      return childNavigators[_mainNavigator];
    }

    return null;
  }

  static String get getCurrentPageOnActiveStack => _currentPageOnActiveStack;

  /*
  |--------------------------------------------------------------------------
  | setters:
  |--------------------------------------------------------------------------
  */

  static set setAppNavigator(GlobalKey<NavigatorState>? navigatorKey) {
    if (navigatorKey == null) return;

    // if already on same tab
    if (navigatorKey == _mainNavigator) {
      pop();
    } else {
      AppLogger.navigationInfo('setMainNavigatior: $navigatorKey');

      _mainNavigator = navigatorKey;

      _switchActivePageStack();

      _addToHistory(navigatorKey);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | public methods:
  |--------------------------------------------------------------------------
  */

  static bool push(BuildContext? context, MaterialPageRoute materialPageRoute, void Function() refreshCallback) {
    // update page stack
    _pushToActivePageStack();

    if (null != context) {
      _setChildNavigator(context);
    }

    var isPushed = () {
      if (_pushToChild(materialPageRoute, refreshCallback)) {
        return false;
      }

      if (_pushToMain(materialPageRoute, refreshCallback)) {
        return false;
      }

      return true;
    }();

    return isPushed;
  }

  static bool pop() {
    // update page stack
    _popPageFromActivePageStack();

    if (_popFromChild()) {
      return true;
    }

    if (_popFromMain()) {
      return true;
    }

    return false;
  }

  static bool popFromRoot(BuildContext context) {
    AppLogger.navigationInfo('popFromRoot');

    Navigator.of(context, rootNavigator: true).maybePop();
    return true;
  }

  static bool popFromContext([BuildContext? fromContext]) {
    // if pop from context
    if (fromContext != null && Navigator.of(fromContext).canPop()) {
      Navigator.of(fromContext).pop();
      return true;
    }

    // else try main pop
    return pop();
  }

  static bool isCurrent(GlobalKey<NavigatorState> navigatorState) => getAppNavigator == navigatorState;

  static bool canPopFromChild() => _canPopFromNavigator(getChildNavigator);

  /*
  |--------------------------------------------------------------------------
  | handle user's back button:
  |--------------------------------------------------------------------------
  */

  static Future<bool> handleBackButton() async {
    // try pop from both main and child navigators
    if (pop()) {
      return false;
    }

    // trash the current page & make sure it wasn't home page
    if (navigatorSwitchHistory.removeLast() != feedsPageNavigator) {
      // handle remaining history pages
      if (navigatorSwitchHistory.isNotEmpty && contextWithProvider != null) {
        // get the page
        var tabHistoryPage = navigatorSwitchHistory.removeLast();

        // remove all copies of that page
        navigatorSwitchHistory.removeWhere((element) => element == tabHistoryPage);

        // broadcast the page
        if (null != contextWithProvider && null != tabHistoryPage) {
          NavigationBloc.of(contextWithProvider!).pushEvent(NavigatorEventChangeNavigatorState(
            contextWithProvider!,
            navigatorStateToSet: tabHistoryPage,
          ));
        }

        return false;
      }
    }

    return true;
  }

  /*
  |--------------------------------------------------------------------------
  | private helper methods:
  |--------------------------------------------------------------------------
  */

  static bool _pushToMain(MaterialPageRoute pageRoute, [Function? refreshCallback]) {
    if (_mainNavigator != null) {
      if (_mainNavigator!.currentState != null) {
        AppLogger.navigationInfo('_pushedToMain: $_mainNavigator');

        if (null != refreshCallback) {
          _mainNavigator!.currentState!.push(pageRoute).then((_) => refreshCallback());
          return true;
        }

        _mainNavigator!.currentState!.push(pageRoute);
        return true;
      }
    }

    return false;
  }

  static bool _pushToChild(MaterialPageRoute pageRoute, [Function? refreshCallback]) {
    if (getChildNavigator != null) {
      AppLogger.navigationInfo('_pushedToChild: $getChildNavigator');

      if (null != refreshCallback) {
        getChildNavigator!.push(pageRoute).then((_) => refreshCallback());
        return true;
      }

      getChildNavigator!.push(pageRoute);
      return true;
    }

    return false;
  }

  static bool _popFromMain() {
    return _popFromNavigator(getAppNavigator?.currentState);
  }

  static bool _popFromChild() {
    NavigatorState? navigatorState = getChildNavigator;

    while (true) {
      // no child
      if (navigatorState == null) return false;

      // break loop if current navigator is main navigator
      if (navigatorState.mounted && navigatorState.widget.key != null) {
        if (mainNavigators.contains(navigatorState.widget.key)) {
          break;
        }
      }

      // check if we can pop from navigator
      if (_canPopFromNavigator(navigatorState)) {
        navigatorState.pop(false);
        return true;
      }

      // else try to get the parent navigator
      navigatorState = navigatorState.context.findAncestorStateOfType<NavigatorState>();

      if (navigatorState != null) {
        // update child navigator
        AppLogger.navigationInfo('_setChildNavigator: $navigatorState');

        childNavigators[getAppNavigator!] = navigatorState;
      } else {
        // clear child navigator
        childNavigators[getAppNavigator!] = null;
      }
    }

    return false;
  }

  static bool _popFromNavigator(NavigatorState? navigatorState) {
    if (_canPopFromNavigator(navigatorState)) {
      navigatorState!.pop();
      return true;
    }

    return false;
  }

  static bool _canPopFromNavigator(NavigatorState? navigatorState) {
    if (navigatorState != null) {
      return navigatorState.canPop();
    }
    return false;
  }

  static _setChildNavigator(BuildContext context) {
    var navigatorState = context.findAncestorStateOfType<NavigatorState>();

    if (_mainNavigator != null && navigatorState != null) {
      childNavigators[_mainNavigator!] = navigatorState;
    }

    AppLogger.navigationInfo('_setChildNavigator: $navigatorState');
  }

  static _switchActivePageStack() {
    if (null == _mainNavigator) return;

    // if stack doesn't exists for current navigator, create one
    if (!_pageStacks.containsKey(_mainNavigator)) {
      _pageStacks[_mainNavigator!] = ['root'];

      AppLogger.navigationInfo('createPageStack: $_mainNavigator');
    }

    _updateCurrentPageOnStack();
  }

  static _updateCurrentPageOnStack() {
    // insanity check
    if (null == _mainNavigator) return;

    var newCurrentPage = _mainNavigator.toString() + '/' + _pageStacks[_mainNavigator]!.last;

    // update current page
    if (_currentPageOnActiveStack != newCurrentPage) {
      _currentPageOnActiveStack = _mainNavigator.toString() + '/' + _pageStacks[_mainNavigator]!.last;

      AppLogger.navigationInfo('setCurrentPageOnStack: $_currentPageOnActiveStack');
    }
  }

  static _pushToActivePageStack() {
    if (null == _mainNavigator || null == _pageStacks[_mainNavigator]) return;

    // push to active stack
    _pageStacks[_mainNavigator]!.add('/page:' + (_pageStacks[_mainNavigator]!.length + 1).toString());

    // update current page on stack
    _updateCurrentPageOnStack();
  }

  static _popPageFromActivePageStack() {
    var navigator = _mainNavigator;

    // if page stack exists
    if (null != navigator && null != _pageStacks[navigator]) {
      // if not on root page
      if (_pageStacks[navigator]!.length > 1) {
        // remove from stack
        _pageStacks[navigator]!.removeLast();

        // update current page on stack
        _updateCurrentPageOnStack();
      }
    }
  }

  static _addToHistory(GlobalKey<NavigatorState>? navigatorState) {
    navigatorSwitchHistory.add(navigatorState);
  }
}
