import 'dart:async';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

/*
|--------------------------------------------------------------------------
| bloc:
|--------------------------------------------------------------------------
*/

class LoginBloc {
  /*
  |--------------------------------------------------------------------------
  | stream controllers:
  |--------------------------------------------------------------------------
  */
  final _stateController = StreamController<LoginState>.broadcast();

  final _eventController = StreamController<LoginEvent>();

  /*
  |--------------------------------------------------------------------------
  | exposed stream
  |--------------------------------------------------------------------------
  */

  Stream<LoginState> get stream => _stateController.stream;

  /*
  |--------------------------------------------------------------------------
  | constructor:
  |--------------------------------------------------------------------------
  */

  LoginBloc() {
    AppLogger.blockInfo("LoginBloc: Init");
    _eventController.stream.listen(_handleEvent);
  }

  /*
  |--------------------------------------------------------------------------
  | push events [exposed]:
  |--------------------------------------------------------------------------
  */

  void pushEvent(LoginEvent event) {
    AppLogger.blockInfo("LoginBloc [UI]: Event ~> ${event.runtimeType}");
    _eventController.sink.add(event);
  }

  /*
  |--------------------------------------------------------------------------
  | push state:
  |--------------------------------------------------------------------------
  */

  void _pushState(LoginState state) {
    AppLogger.blockInfo("LoginBloc: State ~> ${state.runtimeType}");
    _stateController.sink.add(state);
  }

  /*
  |--------------------------------------------------------------------------
  | handle events:
  |--------------------------------------------------------------------------
  */

  void _handleEvent(LoginEvent event) {
    AppLogger.blockInfo("LoginBloc: Handling event <~ ${event.runtimeType}");

    switch (event.runtimeType) {
      case LoginEventTryUsernameAndPassword:
        return _loginEventTryUsernameAndPassword(event as LoginEventTryUsernameAndPassword);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | try login from username and password
  |--------------------------------------------------------------------------
  */

  void _loginEventTryUsernameAndPassword(LoginEventTryUsernameAndPassword event) async {
    try {
      // login in progress
      _pushState(LoginStateLoginInProgress());

      var responseModel =
          await AppProvider.of(event.context).apiRepo.login(username: event.username, password: event.password);

      //  No network
      if (responseModel.isNotResponse) {
        return _pushState(LoginStateNoNetwork());
      }

      switch (responseModel.message) {
        case D_ERROR_USER_MISSING_FIELDS_MSG:
          return _pushState(LoginStateMissingFields());

        // user not found
        case D_ERROR_USER_NOT_FOUND_MSG:
          return _pushState(LoginStateUserNotFound());

        // user credentials not matched
        case D_ERROR_USER_NOT_MATCHED_MSG:
          return _pushState(LoginStateUsernameOrPasswordNotMatched());

        case SUCCESS_MSG:
        case D_ERROR_SESSION_REQUIRES_EMAIL_VERIFICATION:
          // check response for user object
          if (!responseModel.contains(UserTable.tableName)) throw Exception();

          // create user model from response
          var authedUser = UserModel.fromJson(responseModel.first(UserTable.tableName));

          // double check if user data arrived correct from api
          if (authedUser.isNotModel) throw Exception();

          // requires email verification
          if (D_ERROR_SESSION_REQUIRES_EMAIL_VERIFICATION == responseModel.message) {
            return AuthBloc.of(event.context).pushEvent(
              AuthEventRequiresEmailVerification(
                context: event.context,
                authedUser: authedUser,
              ),
            );
          } else {
            // push event to Auth Bloc so stream listener can view home
            return AuthBloc.of(event.context).pushEvent(
              AuthEventSetAuthedUser(event.context, authedUser: authedUser),
            );
          }
      }
    } catch (e) {
      AppLogger.exception(e);
    }

    // our pessimistic catch xD
    _pushState(LoginStateSomethingWentWrong());
  }

  /*
  |--------------------------------------------------------------------------
  | dispose streams [exposed]:
  |--------------------------------------------------------------------------
  */

  void dispose() {
    _eventController.close();
    _stateController.close();

    AppLogger.blockInfo("LoginBloc: Dispose");
  }
}
