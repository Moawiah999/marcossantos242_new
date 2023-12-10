import 'package:flutter/material.dart';

import 'package:photogram/import/bloc.dart';

abstract class TransitionScreen extends StatefulWidget {
  const TransitionScreen({Key? key}) : super(key: key);
}

abstract class LoginScreen extends StatefulWidget {
  final LoginBloc loginBloc = LoginBloc();
  LoginScreen({Key? key}) : super(key: key);
  void dispose();
}

abstract class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
}

abstract class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);
}

abstract class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
}

abstract class NoNetworkScreen extends StatelessWidget {
  const NoNetworkScreen({Key? key}) : super(key: key);
}

abstract class SomethingWentWrongScreen extends StatelessWidget {
  const SomethingWentWrongScreen({Key? key}) : super(key: key);
}
