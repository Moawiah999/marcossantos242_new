import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';

class AppNavigator extends StatefulWidget {
  final AppMainNavigatorPage defaultPage;
  final GlobalKey<NavigatorState> navigatorKey;

  const AppNavigator({
    Key? key,
    required this.defaultPage,
    required this.navigatorKey,
  }) : super(key: key);

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> with AppActiveContentMixin {
  @override
  void onLoadEvent() {
    activeContent.addOrUpdateModel<UserModel>(AppProvider.of(context).auth.getCurrentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) {
            switch (widget.defaultPage) {
              case AppMainNavigatorPage.feedsPage:
                return ThemeBloc.pageInterface.feedsPage(key: KeyGen.from(AppWidgetKey.rootFeedsPage));
              case AppMainNavigatorPage.searchPage:
                return ThemeBloc.pageInterface.searchPage(key: KeyGen.from(AppWidgetKey.rootSearchPage));
              case AppMainNavigatorPage.activityPage:
                return ThemeBloc.pageInterface.activityPage(key: KeyGen.from(AppWidgetKey.rootActivityPage));
              case AppMainNavigatorPage.profilePage:
                return ThemeBloc.pageInterface.profilePage(
                  key: KeyGen.from(AppWidgetKey.rootProfilePage),
                  userId: activeContent.authBloc.getCurrentUser.intId,
                );
            }
          },
        );
      },
    );
  }
}
