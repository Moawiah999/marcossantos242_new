import 'package:photogram/import/data.dart';

abstract class FormEditorState {}

/// Saving event is in progress, maybe show preloader/acitivity indicator
///
class FormEditorStateInProgress extends FormEditorState {}

/// No network
///
class FormEditorStateNoNetwork extends FormEditorState {}

/// Something went wrong
///
class FormEditorStateSomethingWentWrong extends FormEditorState {}

/// Data has been updated
///
class FormEditorStateDataUpdated extends FormEditorState {
  UserModel updatedUserModel;

  FormEditorStateDataUpdated({required this.updatedUserModel});
}

/// Validation/Server error
///
class FormEditorStateValidationError extends FormEditorState {
  Map<String, String> errorMap;

  FormEditorStateValidationError({required this.errorMap});
}
