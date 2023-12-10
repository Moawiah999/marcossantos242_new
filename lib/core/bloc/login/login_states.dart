abstract class LoginState {}

/// Login event is in progress, maybe show preloader/acitivity indicator
///
class LoginStateLoginInProgress extends LoginState {}

/// No network
///
class LoginStateNoNetwork extends LoginState {}

/// Missing Fields
///
class LoginStateMissingFields extends LoginState {}

/// User not found
///
class LoginStateUserNotFound extends LoginState {}

/// User credentials not matched
///
class LoginStateUsernameOrPasswordNotMatched extends LoginState {}

/// Something went wrong
///
class LoginStateSomethingWentWrong extends LoginState {}
