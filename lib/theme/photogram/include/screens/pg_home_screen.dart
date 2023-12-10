import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/bottom_navigation/pg_bottom_navigation_favorite_item.dart';
import 'package:photogram/theme/photogram/include/widgets/bottom_navigation/pg_bottom_navigation_item.dart';

class PgHomeScreen extends HomeScreen {
  const PgHomeScreen({Key? key}) : super(key: key);

  @override
  State<PgHomeScreen> createState() => _PgHomeScreenState();
}

class _PgHomeScreenState extends State<PgHomeScreen> with AppUtilsMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NavigationState>(
      stream: NavigationBloc.of(context).stream,
      builder: (context, snapshot) {
        var currentIndex = NavigationBloc.of(context).currentBottomNavIndex;

        return Scaffold(
          body: SafeArea(
            child: LazyLoadIndexedStack(
              index: currentIndex,
              children: [
                AppNavigator(
                    defaultPage: AppMainNavigatorPage.feedsPage,
                    navigatorKey: AppNavigation.feedsPageNavigator),
                AppNavigator(
                    defaultPage: AppMainNavigatorPage.searchPage,
                    navigatorKey: AppNavigation.searchPageNavigator),
                AppUtils.nothing(),
                AppNavigator(
                    defaultPage: AppMainNavigatorPage.activityPage,
                    navigatorKey: AppNavigation.activityPageNavigator),
                AppNavigator(
                    defaultPage: AppMainNavigatorPage.profilePage,
                    navigatorKey: AppNavigation.profilePageNavigator),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            // add slight border
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 0.1,
                ),
              ),
            ),
            // original nav bar goes here
            child: Material(
              elevation: 4,
              color: Theme.of(context).bottomAppBarColor,
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: Divider.createBorderSide(
                        context,
                        width: 0,
                        color: Theme.of(context).bottomAppBarColor,
                      ),
                    ),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      PgBottomNavigationItem(
                        key: KeyGen.from(AppWidgetKey.feedsPageHomeScreenBottomNavItem),
                        index: 0,
                        activeIndex: currentIndex,
                        onPress: () {
                          NavigationBloc.of(context).pushEvent(NavigatorEventChangeNavigatorState(
                            context,
                            navigatorStateToSet: AppNavigation.feedsPageNavigator,
                          ));
                        },
                      ),
                      PgBottomNavigationItem(
                        key: KeyGen.from(AppWidgetKey.searchPageHomeScreenBottomNavItem),
                        index: 1,
                        activeIndex: currentIndex,
                        onPress: () {
                          NavigationBloc.of(context).pushEvent(NavigatorEventChangeNavigatorState(
                            context,
                            navigatorStateToSet: AppNavigation.searchPageNavigator,
                          ));
                        },
                      ),
                      PgBottomNavigationItem(
                        key: KeyGen.from(AppWidgetKey.addPostPageHomeScreenBottomNavItem),
                        index: 2,
                        activeIndex: currentIndex,
                        iconSize: 22,
                        onPress: () => PgUtils.openCreatePostPage(utilMixinSetState),
                      ),
                      PgBottomNavigationFavoriteItem(
                        key: KeyGen.from(AppWidgetKey.favoritePageHomeScreenBottomNavItem),
                        index: 3,
                        activeIndex: currentIndex,
                        onPress: () {
                          NavigationBloc.of(context).pushEvent(NavigatorEventChangeNavigatorState(
                            context,
                            navigatorStateToSet: AppNavigation.activityPageNavigator,
                          ));
                        },
                      ),
                      PgBottomNavigationItem(
                        key: KeyGen.from(AppWidgetKey.profilePageHomeScreenBottomNavItem),
                        index: 4,
                        activeIndex: currentIndex,
                        onPress: () {
                          NavigationBloc.of(context).pushEvent(NavigatorEventChangeNavigatorState(
                            context,
                            navigatorStateToSet: AppNavigation.profilePageNavigator,
                          ));
                        },
                      ),
                    ],
                  ),
                ),
                bottom: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
