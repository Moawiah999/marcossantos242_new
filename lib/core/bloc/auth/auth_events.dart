import 'package:flutter/material.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';

abstract class AuthEvent {
  final BuildContext context;
  AuthEvent(this.context);
}

/// Log out user, remove creds from local repo and redirect to [LoginScreen]
///
class AuthEventLogout extends AuthEvent {
  AuthEventLogout(BuildContext context) : super(context);
}

class AuthEventRequiresEmailVerification extends AuthEvent {
  final UserModel authedUser;

  AuthEventRequiresEmailVerification({
    required BuildContext context,
    required this.authedUser,
  }) : super(context);
}

/// Try logging in user from creds inside local repo(if exists)
/// On success, redirect to [HomeScreen]
/// On network error, redirect to [OfflineHomeScreen]
///
class AuthEventLoginFromLocalRepo extends AuthEvent {
  AuthEventLoginFromLocalRepo(BuildContext context) : super(context);
}

/// Try logging in user from user's input([LoginScreen])
/// On success, redirect to [HomeScreen]
/// On network error, redirect to [LoginScreen]
///
class AuthEventLoginFromUsernameAndPassword extends AuthEvent {
  final String username;
  final String password;

  AuthEventLoginFromUsernameAndPassword(
    BuildContext context, {
    required this.username,
    required this.password,
  }) : super(context);
}

/// User has been logged in on ([LoginScreen])
/// Set the received user object as current user in [AuthBloc]
///
class AuthEventSetAuthedUser extends AuthEvent {
  final UserModel authedUser;

  AuthEventSetAuthedUser(BuildContext context, {required this.authedUser}) : super(context);
}
