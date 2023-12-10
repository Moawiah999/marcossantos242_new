import 'package:flutter/widgets.dart';

import 'package:photogram/import/data.dart';

abstract class AuthState {
  final BuildContext context;
  AuthState(this.context);
}

/// No credentials found on local repo, show [LoginScreen]/[SignUpScreen]
///
class AuthStateLoggedOut extends AuthState {
  AuthStateLoggedOut(BuildContext context) : super(context);
}

/// Credentials found inside local repo but cannot authenticate
/// possibly because of network error, show [OfflineHomeScreen]
///
class AuthStateNoNetwork extends AuthState {
  final UserModel user;

  AuthStateNoNetwork(BuildContext context, {required this.user}) : super(context);
}

/// User is authenticated successfuly over network show [HomeScreen]
///
class AuthStateAuthed extends AuthState {
  final UserModel authedUser;

  AuthStateAuthed(BuildContext context, {required this.authedUser}) : super(context);
}

/// User is autheticated but requires email verification
///
class AuthStateRequiresEmailVerification extends AuthStateAuthed {
  AuthStateRequiresEmailVerification(
    BuildContext context, {
    required UserModel authedUser,
  }) : super(context, authedUser: authedUser);
}
