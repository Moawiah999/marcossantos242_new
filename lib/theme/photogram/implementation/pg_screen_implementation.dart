import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';

class PgScreenImplementation extends AppScreenInterface {
  PgScreenImplementation({
    required this.homeScreen,
    required this.loginScreen,
    required this.emailVerificationScreen,
    required this.noNetworkScreen,
    required this.somethingWentWrongScreen,
    required this.splashScreen,
    required this.transitionScreen,
  });

  @override
  HomeScreenSignature homeScreen;

  @override
  LoginScreenSignature loginScreen;

  @override
  EmailVerificationScreenSignature emailVerificationScreen;

  @override
  NoNetworkScreenSignature noNetworkScreen;

  @override
  SomethingWentWrongScreenSignature somethingWentWrongScreen;

  @override
  SplashScreenSignature splashScreen;

  @override
  TransitionScreenSignature transitionScreen;
}
