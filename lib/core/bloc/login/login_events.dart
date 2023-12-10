import 'package:flutter/material.dart';

abstract class LoginEvent {
  final BuildContext context;

  LoginEvent(this.context);
}

/// Try logging in user from user's input([LoginScreen])
/// On success, redirect to [HomeScreen]
/// On network error, redirect to [LoginScreen]
///
class LoginEventTryUsernameAndPassword extends LoginEvent {
  final String username;
  final String password;

  LoginEventTryUsernameAndPassword(
    BuildContext context, {
    required this.username,
    required this.password,
  }) : super(context);
}
