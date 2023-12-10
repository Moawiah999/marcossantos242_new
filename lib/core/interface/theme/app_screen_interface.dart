import 'package:photogram/import/core.dart';

abstract class AppScreenInterface {
  abstract HomeScreenSignature homeScreen;

  abstract LoginScreenSignature loginScreen;

  abstract EmailVerificationScreenSignature emailVerificationScreen;

  abstract SplashScreenSignature splashScreen;

  abstract NoNetworkScreenSignature noNetworkScreen;

  abstract TransitionScreenSignature transitionScreen;

  abstract SomethingWentWrongScreenSignature somethingWentWrongScreen;
}
