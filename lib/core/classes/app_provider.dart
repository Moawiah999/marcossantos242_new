import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';

class AppProvider extends InheritedWidget {
  final AuthBloc auth;
  final ThemeBloc theme;
  final NavigationBloc navigation;
  final NotificationsBloc notifications;
  final ApiRepository apiRepo;
  final LocalRepository localRepo;
  final AppContentProvider appContentProvider;

  const AppProvider({
    Key? key,
    required app,
    required this.auth,
    required this.theme,
    required this.navigation,
    required this.notifications,
    required this.apiRepo,
    required this.localRepo,
    required this.appContentProvider,
  }) : super(key: key, child: app);

  static AppProvider of(BuildContext context) => context.findAncestorWidgetOfExactType<AppProvider>() as AppProvider;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
