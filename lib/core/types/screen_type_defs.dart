import 'package:flutter/material.dart';

import 'package:photogram/import/interface.dart';

typedef HomeScreenSignature = HomeScreen Function({Key? key});

typedef LoginScreenSignature = LoginScreen Function({Key? key});

typedef EmailVerificationScreenSignature = EmailVerificationScreen Function({Key? key});

typedef SplashScreenSignature = SplashScreen Function({Key? key});

typedef NoNetworkScreenSignature = NoNetworkScreen Function({Key? key});

typedef TransitionScreenSignature = TransitionScreen Function({Key? key});

typedef SomethingWentWrongScreenSignature = SomethingWentWrongScreen Function({Key? key});
