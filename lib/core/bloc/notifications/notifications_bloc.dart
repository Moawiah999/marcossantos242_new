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

class NotificationsBloc {
  /// instance getter
  static NotificationsBloc of(BuildContext context) => AppProvider.of(context).notifications;

  /*
  |--------------------------------------------------------------------------
  | stream controllers:
  |--------------------------------------------------------------------------
  */

  final _stateController = StreamController<NotificationsState>.broadcast();

  /*
  |--------------------------------------------------------------------------
  | exposed stream
  |--------------------------------------------------------------------------
  */

  Stream<NotificationsState> get stream => _stateController.stream;

  /*
  |--------------------------------------------------------------------------
  | trigger stream:
  |--------------------------------------------------------------------------
  */

  late Stream _triggerStream;

  late StreamSubscription _triggerSub;

  /*
  |--------------------------------------------------------------------------
  | internal data:
  |--------------------------------------------------------------------------
  */

  var _isInitialized = false;
  var _isCallInStack = false;
  var _isActivated = false;

  late BuildContext _context;
  late AuthBloc _authBloc;
  late ApiRepository _apiRepo;

  /*
  |--------------------------------------------------------------------------
  | constructor:
  |--------------------------------------------------------------------------
  */

  NotificationsBloc() {
    AppLogger.blockInfo("NotificationBloc: Init");
  }

  start({
    required BuildContext context,
  }) {
    if (!_isInitialized) {
      AppLogger.blockInfo("NotificationBloc: Start");

      _context = context;

      _authBloc = AuthBloc.of(context);
      _apiRepo = ApiRepository.of(context);

      _triggerStream = Stream.periodic(const Duration(seconds: 10));
      _triggerSub = _triggerStream.listen(_triggerListener);

      _isInitialized = true;
    }
  }

  /*
  |--------------------------------------------------------------------------
  | active/deactivate:
  |--------------------------------------------------------------------------
  */

  void setActivateState(bool toSet) {
    AppLogger.blockInfo("NotificationBloc: ${toSet ? 'Activated' : 'De-activated'}");

    _isActivated = toSet;
  }

  /*
  |--------------------------------------------------------------------------
  | trigger polling:
  |--------------------------------------------------------------------------
  */

  void _triggerListener(_) async {
    if (!_isActivated) {
      _unRegisterCall();

      return;
    }

    // register call
    if (!_registerCall()) return;

    try {
      var responseModel = await _apiRepo.preparedRequest(
        requestType: REQ_TYPE_NOTIFICATION_COUNT,
        requestData: {},
      );

      if (_isActivated) {
        switch (responseModel.message) {
          case D_ERROR_SESSION_UNAUTHORIZED_MSG:
            if (_authBloc.getCurrentUser.isModel) {
              _authBloc.pushEvent(AuthEventLogout(_context));
            }

            break;

          case D_ERROR_SESSION_REQUIRES_EMAIL_VERIFICATION:
            if (_authBloc.getCurrentUser.isModel) {
              _authBloc.pushEvent(
                AuthEventRequiresEmailVerification(
                  context: _context,
                  authedUser: _authBloc.getCurrentUser,
                ),
              );
            }

            break;

          case SUCCESS_MSG:
            if (responseModel.contains(NotificationsCountDTO.dtoName)) {
              var notificationsCountDTO =
                  NotificationsCountDTO.fromJson(responseModel.first(NotificationsCountDTO.dtoName));

              if (notificationsCountDTO.isDTO) {
                _pushState(NotificationsState(notificationsCountDTO));
              }
            }
            break;
        }
      }
    } catch (e) {
      AppLogger.exception(e);
    } finally {
      _unRegisterCall();
    }
  }

  bool _registerCall() {
    if (_isCallInStack) return false;
    _isCallInStack = true;
    return true;
  }

  bool _unRegisterCall() {
    if (!_isCallInStack) return false;
    _isCallInStack = false;
    return true;
  }

  /*
  |--------------------------------------------------------------------------
  | push state:
  |--------------------------------------------------------------------------
  */

  void _pushState(NotificationsState state) {
    AppLogger.blockInfo("NotificationsBloc: State ~> ${state.runtimeType}");
    _stateController.sink.add(state);
  }

  /*
  |--------------------------------------------------------------------------
  | dispose streams [exposed]:
  |--------------------------------------------------------------------------
  */

  void dispose() {
    _triggerSub.cancel();
    _stateController.close();
    AppLogger.blockInfo("NotificationBloc: Dispose");
  }
}
