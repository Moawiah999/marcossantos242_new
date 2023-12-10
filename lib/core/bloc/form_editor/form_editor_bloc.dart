import 'dart:async';

import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

/*
|--------------------------------------------------------------------------
| bloc:
|--------------------------------------------------------------------------
*/

class FormEditorBloc {
  /*
  |--------------------------------------------------------------------------
  | field type to contain field specific implementation:
  |--------------------------------------------------------------------------
  */

  final FormEditorType formEditorType;

  /*
  |--------------------------------------------------------------------------
  | stream controllers:
  |--------------------------------------------------------------------------
  */
  final _stateController = StreamController<FormEditorState>.broadcast();

  final _eventController = StreamController<FormEditorEvent>();

  /*
  |--------------------------------------------------------------------------
  | exposed stream
  |--------------------------------------------------------------------------
  */

  Stream<FormEditorState> get stream => _stateController.stream;

  /*
  |--------------------------------------------------------------------------
  | constructor:
  |--------------------------------------------------------------------------
  */

  FormEditorBloc({required this.formEditorType}) {
    AppLogger.blockInfo("FormEditorBloc<${formEditorType.runtimeType}>: Init");
    _eventController.stream.listen(_handleEvent);
  }

  /*
  |--------------------------------------------------------------------------
  | push events [exposed]:
  |--------------------------------------------------------------------------
  */

  void pushEvent(FormEditorEvent event) {
    AppLogger.blockInfo("FormEditorBloc<${formEditorType.runtimeType}> [UI]: Event ~> ${event.runtimeType}");
    _eventController.sink.add(event);
  }

  /*
  |--------------------------------------------------------------------------
  | push state:
  |--------------------------------------------------------------------------
  */

  void _pushState(FormEditorState state) {
    AppLogger.blockInfo("FormEditorBloc<${formEditorType.runtimeType}>: State ~> ${state.runtimeType}");
    _stateController.sink.add(state);
  }

  /*
  |--------------------------------------------------------------------------
  | handle events:
  |--------------------------------------------------------------------------
  */

  void _handleEvent(FormEditorEvent event) {
    AppLogger.blockInfo("FormEditorBloc<${formEditorType.runtimeType}>: Handling event <~ ${event.runtimeType}");

    switch (event.runtimeType) {
      case FormEditorEventSaveFieldsData:
        return _saveFieldsData(event as FormEditorEventSaveFieldsData);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | try saving field data
  |--------------------------------------------------------------------------
  */

  void _saveFieldsData(FormEditorEventSaveFieldsData event) async {
    try {
      // login in progress
      _pushState(FormEditorStateInProgress());

      var responseModel = await AppProvider.of(event.context).apiRepo.preparedRequest(
        requestType: formEditorType.requestType,
        requestData: {UserTable.tableName: event.fieldDataMap},
      );

      //  No network
      if (responseModel.isNotResponse) {
        return _pushState(FormEditorStateNoNetwork());
      }

      switch (responseModel.message) {
        case SUCCESS_MSG:

          // check response for user object
          if (!responseModel.contains(UserTable.tableName)) throw Exception();

          // create user model from response
          var authedUser = UserModel.fromJson(responseModel.first(UserTable.tableName));

          // double check if user data arrived correct from api
          if (authedUser.isNotModel) throw Exception();

          // update the auth bloc
          AppProvider.of(event.context).auth.pushEvent(
                AuthEventSetAuthedUser(event.context, authedUser: authedUser),
              );

          // push updated data state
          _pushState(FormEditorStateDataUpdated(updatedUserModel: authedUser));

          return;

        // else throw field specific error
        default:
          return _pushState(
            FormEditorStateValidationError(
              errorMap: formEditorType.getErrorMap(responseModel.message),
            ),
          );
      }
    } catch (e) {
      AppLogger.exception(e);
    }

    _pushState(FormEditorStateSomethingWentWrong());
  }

  /*
  |--------------------------------------------------------------------------
  | dispose streams [exposed]:
  |--------------------------------------------------------------------------
  */

  void dispose() {
    _eventController.close();
    _stateController.close();

    AppLogger.blockInfo("FormEditorBloc<${formEditorType.runtimeType}>: Dispose");
  }
}
