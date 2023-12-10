import 'package:flutter/material.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // initialise them here! why?
  // 1. no mem leaks
  // 2. widget's build method must not do any side effects!

  final _auth = AuthBloc();
  final _theme = ThemeBloc();
  final _navigation = NavigationBloc();
  final _appContentProvider = AppContentProvider();

  final _apiRepo = ApiRepository();
  final _localRepo = LocalRepository();
  final _notifications = NotificationsBloc();

  @override
  void initState() {
    super.initState();
    AppSettings.init(_apiRepo);
  }

  @override
  Widget build(BuildContext context) {
    /*
    |--------------------------------------------------------------------------
    | build app
    |--------------------------------------------------------------------------
    */

    return AppProvider(
      auth: _auth,
      theme: _theme,
      navigation: _navigation,
      apiRepo: _apiRepo,
      localRepo: _localRepo,
      notifications: _notifications,
      appContentProvider: _appContentProvider,
      app: StreamBuilder<ThemeState>(
        stream: _theme.stream,
        builder: (context, snapshot) {
          return MaterialApp(
            // title and homescreen
            title: APP_NAME,

            // app screen builder
            home: WillPopScope(
              // when user press back button
              onWillPop: AppNavigation.handleBackButton,

              child: Builder(
                builder: (context) {
                  // initiate time ago parser
                  // no-side effects
                  AppTimeAgoParser(context);

                  // same, no-side effects
                  _notifications.start(context: context);

                  // pass context to main navigation
                  AppNavigation.contextWithProvider = context;

                  // build scree
                  return AppScreenBuilder(
                    context: context,
                    screen: ThemeBloc.screenInterface.transitionScreen(),
                  );
                },
              ),
            ),

            theme: ThemeBloc.getThemeData,

            // localization
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,

            // disable debug banner inside app
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _auth.dispose();
    _theme.dispose();
    _navigation.dispose();
    _appContentProvider.dispose();
    super.dispose();
  }
}
