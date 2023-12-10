import 'package:flutter/material.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgLoginScreen extends LoginScreen {
  PgLoginScreen({Key? key}) : super(key: key);

  @override
  State<PgLoginScreen> createState() => _PgLoginScreenState();

  @override
  void dispose() => loginBloc.dispose();
}

class _PgLoginScreenState extends State<PgLoginScreen> with AppUtilsMixin {
  final _usernameOrEmailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return bodyNew(context);
    // return bodyOld(context);
  }

  Scaffold bodyNew(BuildContext context) {
    final inputBorder = OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Image.asset(
                'assets/png/Spalhe.png',
                height: 50,
                color: ThemeBloc.colorScheme.onBackground,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Image.asset(
                  'assets/png/color_spalhe.png',
                  height: 9,
                ),
              ),
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Text(
                AppLocalizations.of(context)!.loginToContinue,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(
                height: 64,
              ),
              TextFormField(
                controller: _usernameOrEmailController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.inputPlaceholderUsername,
                  border: inputBorder,
                  focusedBorder: inputBorder,
                  enabledBorder: inputBorder,
                  filled: true,
                  contentPadding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    hintText: 'password',
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    enabledBorder: inputBorder,
                    filled: true,
                    contentPadding: const EdgeInsets.all(8)),
                obscureText: true,
              ),
              const SizedBox(
                height: 24,
              ),
              StreamBuilder<LoginState>(
                  stream: widget.loginBloc.stream,
                  builder: (context, snapshot) {
                    // show error message(if exists in stream state)
                    if (snapshot.hasData) {
                      switch (snapshot.data.runtimeType) {
                        case LoginStateNoNetwork:
                          PgUtils.showMessageInsidePopUp(
                              context: context,
                              waitForFrame: true,
                              message: AppLocalizations.of(context)!.noNetworkMessage);
                          break;
                        case LoginStateSomethingWentWrong:
                          PgUtils.showMessageInsidePopUp(
                              context: context,
                              waitForFrame: true,
                              message: AppLocalizations.of(context)!.somethingWentWrongMessage);
                          break;
                        case LoginStateMissingFields:
                          PgUtils.showMessageInsidePopUp(
                            key: KeyGen.from(AppWidgetKey.missingFieldsLoginScreenMessageDialog),
                            context: context,
                            waitForFrame: true,
                            message: AppLocalizations.of(context)!.loginErrorMissingFields,
                          );
                          break;
                        case LoginStateUserNotFound:
                          PgUtils.showMessageInsidePopUp(
                            key: KeyGen.from(AppWidgetKey.nonExistingUserLoginScreenMessageDialog),
                            context: context,
                            waitForFrame: true,
                            message: AppLocalizations.of(context)!.loginErrorUserNotFound,
                          );
                          break;
                        case LoginStateUsernameOrPasswordNotMatched:
                          PgUtils.showMessageInsidePopUp(
                            key: KeyGen.from(AppWidgetKey.incorrectUserCredentialsLoginScreenMessageDialog),
                            context: context,
                            waitForFrame: true,
                            message: AppLocalizations.of(context)!.loginErrorUsernameOrPasswordNotMatched,
                          );
                          break;
                      }
                    }

                    return InkWell(
                      child: Container(
                        child: Text(
                          snapshot.hasData && snapshot.data is LoginStateLoginInProgress
                              ? AppLocalizations.of(context)!.loggingIn
                              : AppLocalizations.of(context)!.login,
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.white),
                        ),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            gradient: LinearGradient(colors: [
                              Color(0xFF405de6),
                              Color(0xFF833ab4),
                              Color(0xFFe1306c),
                            ])),
                      ),
                      onTap: () {
                        if (snapshot.hasData && snapshot.data.runtimeType is LoginStateLoginInProgress) {
                          return;
                        } else {
                          widget.loginBloc.pushEvent(LoginEventTryUsernameAndPassword(
                            context,
                            username: _usernameOrEmailController.text,
                            password: _passwordController.text,
                          ));
                        }
                      },
                    );
                  }),
              const SizedBox(
                height: 12,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: ThemeBloc.textInterface.normalBlackH5Text(
                        text: AppLocalizations.of(context)!.forgetPasswordHelpLine,
                      ),
                    ),
                    const TextSpan(text: ' '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => PgUtils.openRecoverAccountPage(context, utilMixinSetState),
                        child: ThemeBloc.textInterface.normalThemeH5Text(
                          text: AppLocalizations.of(context)!.getHelp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: ThemeBloc.textInterface.normalBlackH5Text(
                            text: AppLocalizations.of(context)!.dontHaveAnAccountLine,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => PgUtils.openRegistrationPage(context, utilMixinSetState),
                            child: ThemeBloc.textInterface.normalThemeH5Text(
                              text: AppLocalizations.of(context)!.signUp,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Scaffold bodyOld(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/png/Spalhe.png',
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Image.asset(
                          'assets/png/color_spalhe.png',
                          height: 6,
                        ),
                      ),
                      PgUtils.sizedBoxH(32),
                      ThemeBloc.textInterface.normalBlackH4Text(
                        text: AppLocalizations.of(context)!.loginToContinue,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Column(
                          children: [
                            PgUtils.sizedBoxH(24),
                            ThemeBloc.widgetInterface.primaryTextField(
                              context: context,
                              key: KeyGen.from(AppWidgetKey.usernameLoginScreenTextField),
                              controller: _usernameOrEmailController,
                              hintText: AppLocalizations.of(context)!.inputPlaceholderUsername,
                            ),
                            PgUtils.sizedBoxH(24),
                            ThemeBloc.widgetInterface.primaryTextField(
                              context: context,
                              key: KeyGen.from(AppWidgetKey.passwordLoginScreenTextField),
                              controller: _passwordController,
                              hintText: AppLocalizations.of(context)!.inputPlaceholderPassword,
                              obscureText: true,
                            ),
                            PgUtils.sizedBoxH(24),
                            StreamBuilder<LoginState>(
                              stream: widget.loginBloc.stream,
                              builder: (context, snapshot) {
                                // show error message(if exists in stream state)
                                if (snapshot.hasData) {
                                  switch (snapshot.data.runtimeType) {
                                    case LoginStateNoNetwork:
                                      PgUtils.showMessageInsidePopUp(
                                          context: context,
                                          waitForFrame: true,
                                          message: AppLocalizations.of(context)!.noNetworkMessage);
                                      break;
                                    case LoginStateSomethingWentWrong:
                                      PgUtils.showMessageInsidePopUp(
                                          context: context,
                                          waitForFrame: true,
                                          message: AppLocalizations.of(context)!.somethingWentWrongMessage);
                                      break;
                                    case LoginStateMissingFields:
                                      PgUtils.showMessageInsidePopUp(
                                        key: KeyGen.from(AppWidgetKey.missingFieldsLoginScreenMessageDialog),
                                        context: context,
                                        waitForFrame: true,
                                        message: AppLocalizations.of(context)!.loginErrorMissingFields,
                                      );
                                      break;
                                    case LoginStateUserNotFound:
                                      PgUtils.showMessageInsidePopUp(
                                        key:
                                            KeyGen.from(AppWidgetKey.nonExistingUserLoginScreenMessageDialog),
                                        context: context,
                                        waitForFrame: true,
                                        message: AppLocalizations.of(context)!.loginErrorUserNotFound,
                                      );
                                      break;
                                    case LoginStateUsernameOrPasswordNotMatched:
                                      PgUtils.showMessageInsidePopUp(
                                        key: KeyGen.from(
                                            AppWidgetKey.incorrectUserCredentialsLoginScreenMessageDialog),
                                        context: context,
                                        waitForFrame: true,
                                        message: AppLocalizations.of(context)!
                                            .loginErrorUsernameOrPasswordNotMatched,
                                      );
                                      break;
                                  }
                                }

                                return SizedBox(
                                  width: double.infinity,
                                  child: ThemeBloc.widgetInterface.themeButton(
                                    key: KeyGen.from(AppWidgetKey.loginLoginScreenButton),
                                    text: snapshot.hasData && snapshot.data is LoginStateLoginInProgress
                                        ? AppLocalizations.of(context)!.loggingIn
                                        : AppLocalizations.of(context)!.login,
                                    onTapCallback: () {
                                      if (snapshot.hasData &&
                                          snapshot.data.runtimeType is LoginStateLoginInProgress) {
                                        return;
                                      } else {
                                        widget.loginBloc.pushEvent(LoginEventTryUsernameAndPassword(
                                          context,
                                          username: _usernameOrEmailController.text,
                                          password: _passwordController.text,
                                        ));
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                            PgUtils.sizedBoxH(24),
                            RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: ThemeBloc.textInterface.normalBlackH5Text(
                                      text: AppLocalizations.of(context)!.forgetPasswordHelpLine,
                                    ),
                                  ),
                                  const TextSpan(text: ' '),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () => PgUtils.openRecoverAccountPage(context, utilMixinSetState),
                                      child: ThemeBloc.textInterface.normalThemeH5Text(
                                        text: AppLocalizations.of(context)!.getHelp,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: ThemeBloc.textInterface.normalBlackH5Text(
                          text: AppLocalizations.of(context)!.dontHaveAnAccountLine,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => PgUtils.openRegistrationPage(context, utilMixinSetState),
                          child: ThemeBloc.textInterface.normalThemeH5Text(
                            text: AppLocalizations.of(context)!.signUp,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
