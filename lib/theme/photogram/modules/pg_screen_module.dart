import 'package:flutter/material.dart';

import 'package:photogram/import/interface.dart';
import 'package:photogram/import/theme.dart';
import 'package:photogram/theme/photogram/include/screens/pg_email_verification_screen.dart';

import 'package:photogram/theme/photogram/include/screens/pg_transitioning_screen.dart';
import 'package:photogram/theme/photogram/include/screens/pg_something_went_wrong_screen.dart';
import 'package:photogram/theme/photogram/include/screens/pg_home_screen.dart';
import 'package:photogram/theme/photogram/include/screens/pg_splash_screen.dart';
import 'package:photogram/theme/photogram/include/screens/pg_no_network_screen.dart';
import 'package:photogram/theme/photogram/include/screens/pg_login_screen.dart';

class PgScreenModule {
  PhotogramTheme photogramTheme;
  PgScreenModule(this.photogramTheme);

  HomeScreen homeScreen({Key? key}) => PgHomeScreen(key: key);

  LoginScreen loginScreen({Key? key}) => PgLoginScreen(key: key);

  EmailVerificationScreen emailVerificationScreen({Key? key}) => PgEmailVerificationScreen(key: key);

  SplashScreen splashScreen({Key? key}) => PgSplashScreen(key: key);

  NoNetworkScreen noNetworkScreen({Key? key}) => PgNoNetworkScreen(key: key);

  TransitionScreen transitionScreen({Key? key}) => PgTransitioningScreen(key: key);

  SomethingWentWrongScreen somethingWentWrongScreen({Key? key}) => PgSomethingWentWrongScreen(key: key);
}
