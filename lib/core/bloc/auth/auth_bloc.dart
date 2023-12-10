import 'dart:async';

import 'package:flutter/material.dart';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

/*
|--------------------------------------------------------------------------
| bloc:
|--------------------------------------------------------------------------
*/

class AuthBloc {
  static AuthBloc of(BuildContext context) => AppProvider.of(context).auth;

  /*
  |--------------------------------------------------------------------------
  | stream controllers:
  |--------------------------------------------------------------------------
  */

  final _stateController = StreamController<AuthState>.broadcast();

  final _eventController = StreamController<AuthEvent>();

  /*
  |--------------------------------------------------------------------------
  | exposed stream
  |--------------------------------------------------------------------------
  */

  Stream<AuthState> get stream => _stateController.stream;

  /*
  |--------------------------------------------------------------------------
  | exposed authed user
  |--------------------------------------------------------------------------
  */

  UserModel get getCurrentUser => _authedUser;

  /*
  |--------------------------------------------------------------------------
  | hold authed user here
  |--------------------------------------------------------------------------
  */

  var _authedUser = UserModel();

  /*
  |--------------------------------------------------------------------------
  | constructor:
  |--------------------------------------------------------------------------
  */

  AuthBloc() {
    AppLogger.blockInfo("AuthBloc: Init");
    _eventController.stream.listen(_handleEvent);
  }

  /*
  |--------------------------------------------------------------------------
  | push events [exposed]:
  |--------------------------------------------------------------------------
  */

  void pushEvent(AuthEvent event) {
    AppLogger.blockInfo("AuthBloc [UI]: Event ~> ${event.runtimeType}");
    _eventController.sink.add(event);
  }

  /*
  |--------------------------------------------------------------------------
  | push events [internal]:
  |--------------------------------------------------------------------------
  */

  void _pushEventInternally(AuthEvent event) {
    AppLogger.blockInfo("AuthBloc [Internally]: Event ~> ${event.runtimeType}");
    _eventController.sink.add(event);
  }

  /*
  |--------------------------------------------------------------------------
  | push state:
  |--------------------------------------------------------------------------
  */

  void _pushState(AuthState state) {
    AppLogger.blockInfo("AuthBloc: State ~> ${state.runtimeType}");

    // do internal state changes (if any)
    switch (state.runtimeType) {
      case AuthStateAuthed:
      case AuthStateRequiresEmailVerification:
        _setUserAsAuthed(state as AuthStateAuthed);
        break;

      case AuthStateLoggedOut:
        _setUserAsLoggedOut(state as AuthStateLoggedOut);

        break;
    }

    // push the state to listeners
    _stateController.sink.add(state);
  }

  /*
  |--------------------------------------------------------------------------
  | handle events:
  |--------------------------------------------------------------------------
  */

  void _handleEvent(AuthEvent event) {
    AppLogger.blockInfo("AuthBloc: Handling event <~ ${event.runtimeType}");

    switch (event.runtimeType) {
      case AuthEventLogout:
        return _authEventLogout(event as AuthEventLogout);

      case AuthEventRequiresEmailVerification:
        return _authEventRequiresEmailVerification(event as AuthEventRequiresEmailVerification);

      case AuthEventLoginFromLocalRepo:
        return _authEventLoginFromLocalRepo(event as AuthEventLoginFromLocalRepo);

      case AuthEventSetAuthedUser:
        return _authEventSetAuthedUser(event as AuthEventSetAuthedUser);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | set logged in user, user is authed and received from some other component
  |--------------------------------------------------------------------------
  */

  void _authEventSetAuthedUser(AuthEventSetAuthedUser event) async {
    try {
      AppProvider.of(event.context).localRepo.saveCurrentUser(event.authedUser);

      var apiRepo = AppProvider.of(event.context).apiRepo;

      _addCookies(apiRepo, event.authedUser);

      NotificationsBloc.of(event.context).setActivateState(true);
    } catch (e) {
      AppLogger.exception(e);
    }

    _pushState(AuthStateAuthed(event.context, authedUser: event.authedUser));
  }

  /*
  |--------------------------------------------------------------------------
  | try login from local repo(first visit usually):
  |--------------------------------------------------------------------------
  */

  void _authEventLoginFromLocalRepo(AuthEventLoginFromLocalRepo event) async {
    try {
      var user = await AppProvider.of(event.context).localRepo.readCurrentUser();

      if (user.isNotModel) throw Exception();

      var apiRepo = AppProvider.of(event.context).apiRepo;

      _addCookies(apiRepo, user);

      var responseModel = await apiRepo.authSession();

      if (responseModel.isNotResponse) {
        return _pushState(AuthStateNoNetwork(event.context, user: user));
      }

      if (responseModel.message != SUCCESS_MSG) {
        throw Exception();
      }

      if (!responseModel.contains(UserTable.tableName)) {
        throw Exception();
      }

      var authedUser = UserModel.fromJson(responseModel.first(UserTable.tableName));

      if (!authedUser.isModel) {
        throw Exception();
      }

      _pushState(AuthStateAuthed(event.context, authedUser: authedUser));
    } catch (e) {
      // user doesn't logged in or not exists in local repo
      // perform complete log out
      _pushEventInternally(AuthEventLogout(event.context));
    }
  }

  /*
  |--------------------------------------------------------------------------
  | requires email verification event:
  |--------------------------------------------------------------------------
  */

  void _authEventRequiresEmailVerification(AuthEventRequiresEmailVerification event) {
    try {
      AppProvider.of(event.context).localRepo.saveCurrentUser(event.authedUser);

      var apiRepo = AppProvider.of(event.context).apiRepo;

      _addCookies(apiRepo, event.authedUser);
    } catch (e) {
      AppLogger.exception(e);
    }

    NotificationsBloc.of(event.context).setActivateState(false);

    _pushState(AuthStateRequiresEmailVerification(event.context, authedUser: event.authedUser));
  }

  /*
  |--------------------------------------------------------------------------
  | logout event:
  |--------------------------------------------------------------------------
  */

  void _authEventLogout(AuthEventLogout event) {
    var apiRepo = AppProvider.of(event.context).apiRepo;
    var localRepo = AppProvider.of(event.context).localRepo;

    NotificationsBloc.of(event.context).setActivateState(false);

    apiRepo.preparedRequest(requestType: REQ_TYPE_LOGOUT, requestData: {});

    _removeCookies(apiRepo);

    localRepo.deleteCurrentUser();

    // push the logged out state
    _pushState(AuthStateLoggedOut(event.context));
  }

  void _addCookies(ApiRepository apiRepo, UserModel userModel) {
    apiRepo.addCookie(UserTable.tableName + "_" + UserTable.id, userModel.id);
    apiRepo.addCookie(UserTable.tableName + "_" + UserTable.metaAccess, userModel.metaAccess);
  }

  void _removeCookies(ApiRepository apiRepo) {
    apiRepo.removeCookie(UserTable.tableName + "_" + UserTable.id);
    apiRepo.removeCookie(UserTable.tableName + "_" + UserTable.metaAccess);
  }

  /*
  |--------------------------------------------------------------------------
  | helper functions:
  |--------------------------------------------------------------------------
  */

  void _setUserAsAuthed(AuthStateAuthed state) {
    _authedUser = state.authedUser;
  }

  void _setUserAsLoggedOut(AuthStateLoggedOut state) {
    _authedUser = UserModel.none();
  }

  /*
  |--------------------------------------------------------------------------
  | dispose streams [exposed]:
  |--------------------------------------------------------------------------
  */

  void dispose() {
    _eventController.close();
    _stateController.close();

    AppLogger.blockInfo("AuthBloc: Dispose");
  }
}
