import 'package:flutter/material.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:sprintf/sprintf.dart';

class PgRegistrationPage extends RegistrationPage {
  const PgRegistrationPage({Key? key}) : super(key: key);

  @override
  State<PgRegistrationPage> createState() => _PgRegistrationPageState();
}

class _PgRegistrationPageState extends State<PgRegistrationPage> with AppActiveContentMixin, AppUtilsMixin {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _isRegistrationInProgress = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      Column(
                        children: [
                          Image.asset(
                            'assets/png/Spalhe.png',
                            height: 50,
                            color: ThemeBloc.colorScheme.onBackground,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Image.asset(
                              'assets/png/color_spalhe.png',
                              height: 10,
                            ),
                          ),
                        ],
                      ),
                      PgUtils.sizedBoxH(32),
                      ThemeBloc.textInterface.normalBlackH4Text(
                        text: AppLocalizations.of(context)!.signupForAAccount,
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Column(
                          children: [
                            PgUtils.sizedBoxH(24),
                            ThemeBloc.widgetInterface.primaryTextField(
                              context: context,
                              key: KeyGen.from(AppWidgetKey.emailRegisterPageTextField),
                              controller: _emailController,
                              hintText: AppLocalizations.of(context)!.enterYourEmail,
                            ),
                            PgUtils.sizedBoxH(24),
                            ThemeBloc.widgetInterface.primaryTextField(
                              context: context,
                              key: KeyGen.from(AppWidgetKey.usernameRegisterPageTextField),
                              controller: _usernameController,
                              hintText: AppLocalizations.of(context)!.chooseAUsername,
                            ),
                            PgUtils.sizedBoxH(24),
                            ThemeBloc.widgetInterface.primaryTextField(
                              context: context,
                              key: KeyGen.from(AppWidgetKey.passwordRegisterPageTextField),
                              controller: _passwordController,
                              hintText: AppLocalizations.of(context)!.chooseAPassword,
                              obscureText: true,
                            ),
                            PgUtils.sizedBoxH(30),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: RichText(
                                text: TextSpan(
                                  style: ThemeBloc.textInterface.normalGreyH1TextStyle(),
                                  children: [
                                    WidgetSpan(
                                      child: ThemeBloc.textInterface.normalGreyH5Text(
                                        text: AppLocalizations.of(context)!.bySigningUp,
                                      ),
                                    ),
                                    const TextSpan(text: ' '),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () => PgUtils.openApiDocument(context, 'privacy_policy'),
                                        child: ThemeBloc.textInterface.normalThemeH5Text(
                                          text: AppLocalizations.of(context)!.privacyPolicy,
                                        ),
                                      ),
                                    ),
                                    const TextSpan(text: ' '),
                                    WidgetSpan(
                                      child: ThemeBloc.textInterface.normalGreyH5Text(
                                        text: AppLocalizations.of(context)!.and,
                                      ),
                                    ),
                                    const TextSpan(text: ' '),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () => PgUtils.openApiDocument(context, 'tos'),
                                        child: ThemeBloc.textInterface.normalThemeH5Text(
                                          text: AppLocalizations.of(context)!.tos,
                                        ),
                                      ),
                                    ),
                                    const TextSpan(text: ' '),
                                    WidgetSpan(
                                      child: ThemeBloc.textInterface.normalGreyH5Text(
                                        text: AppLocalizations.of(context)!.ofOurService,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            PgUtils.sizedBoxH(24),
                            SizedBox(
                              width: double.infinity,
                              child: ThemeBloc.widgetInterface.themeButton(
                                key: KeyGen.from(AppWidgetKey.signUpRegistrationPageButton),
                                text: _isRegistrationInProgress
                                    ? AppLocalizations.of(context)!.signingUp
                                    : AppLocalizations.of(context)!.signUp,
                                onTapCallback: _processRegistration,
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
                          text: AppLocalizations.of(context)!.alreadyHaveAnAccountLine,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: AppNavigation.pop,
                          child: ThemeBloc.textInterface.normalThemeH5Text(
                            text: AppLocalizations.of(context)!.login,
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

  void _processRegistration() async {
    if (_isRegistrationInProgress) return;

    utilMixinSetState(() {
      _isRegistrationInProgress = true;
    });

    var responseModel =
        await activeContent.apiRepository.preparedRequest(requestType: REQ_TYPE_REGISTER, requestData: {
      UserTable.tableName: {
        UserTable.email: _emailController.value.text,
        UserTable.username: _usernameController.value.text,
        UserTable.password: _passwordController.value.text,
      }
    });

    switch (responseModel.message) {
      case D_ERROR_USER_MISSING_FIELDS_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: AppLocalizations.of(context)!.registerErrorMissingFields,
          );
        });

      case D_ERROR_USER_EMAIL_NOT_AVAILABLE_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: AppLocalizations.of(context)!.fieldErrorUserEmailNotAvailable,
          );
        });

      case D_ERROR_USER_EMAIL_INVALID_FORMAT_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: AppLocalizations.of(context)!.fieldErrorUserEmailInvalidFormat,
          );
        });

      case D_ERROR_USER_EMAIL_MAX_LEN_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: sprintf(
              AppLocalizations.of(context)!.fieldErrorUserEmailMaxLength,
              [
                AppSettings.getString(SETTING_MAX_LEN_USER_EMAIL),
              ],
            ),
          );
        });

      case D_ERROR_USER_EMAIL_MIN_LEN_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: sprintf(
              AppLocalizations.of(context)!.fieldErrorUserEmailMinLength,
              [
                AppSettings.getString(SETTING_MIN_LEN_USER_EMAIL),
              ],
            ),
          );
        });

      case D_ERROR_USER_USERNAME_MAX_LEN_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: sprintf(
              AppLocalizations.of(context)!.fieldErrorUserUsernameMaxLength,
              [
                AppSettings.getString(SETTING_MAX_LEN_USER_USERNAME),
              ],
            ),
          );
        });

      case D_ERROR_USER_USERNAME_MIN_LEN_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: sprintf(
              AppLocalizations.of(context)!.fieldErrorUserUsernameMinLength,
              [
                AppSettings.getString(SETTING_MIN_LEN_USER_USERNAME),
              ],
            ),
          );
        });

      case D_ERROR_USER_USERNAME_NOT_AVAILABLE_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: AppLocalizations.of(context)!.fieldErrorUserUsernameNotAvailable,
          );
        });

      case D_ERROR_USER_USERNAME_STARTS_WITH_ALHPABET_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: AppLocalizations.of(context)!.fieldErrorUserUsernameMustStartsWithAlphabet,
          );
        });

      case D_ERROR_USER_USERNAME_ALLOWED_CHARACTERS_ONLY_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: AppLocalizations.of(context)!.fieldErrorUserUsernameAllowedCharactersOnly,
          );
        });

      case D_ERROR_USER_PASSWORD_MAX_LEN_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: sprintf(
              AppLocalizations.of(context)!.fieldErrorUserPasswordMaxLength,
              [
                AppSettings.getString(SETTING_MAX_LEN_USER_PASSWORD),
              ],
            ),
          );
        });

      case D_ERROR_USER_PASSWORD_MIN_LEN_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: sprintf(
              AppLocalizations.of(context)!.fieldErrorUserPasswordMinLength,
              [
                AppSettings.getString(SETTING_MIN_LEN_USER_PASSWORD),
              ],
            ),
          );
        });

      case D_ERROR_USER_NOT_MATCHED_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: AppLocalizations.of(context)!.loginErrorPasswordNotMatched,
          );
        });

      case D_ERROR_USER_PASSWORD_MISMATCH_MSG:
        return utilMixinSetState(() {
          _isRegistrationInProgress = false;
          ThemeBloc.actionInterface.showMessageInsidePopUp(
            context: context,
            waitForFrame: false,
            message: AppLocalizations.of(context)!.fieldErrorUserPasswordMismatch,
          );
        });

      case D_ERROR_SESSION_REQUIRES_EMAIL_VERIFICATION:
      case SUCCESS_MSG:
        // check response for user object
        if (!responseModel.contains(UserTable.tableName)) {
          utilMixinSetState(() {
            _isRegistrationInProgress = false;
            utilMixinSomethingWentWrongMessage();
          });

          break;
        }

        var authedUser = UserModel.fromJson(responseModel.first(UserTable.tableName));

        if (authedUser.isNotModel) throw Exception();

        AppNavigation.pop();

        if (D_ERROR_SESSION_REQUIRES_EMAIL_VERIFICATION == responseModel.message) {
          activeContent.authBloc.pushEvent(
            AuthEventRequiresEmailVerification(
              context: context,
              authedUser: authedUser,
            ),
          );
        } else {
          activeContent.authBloc.pushEvent(AuthEventSetAuthedUser(context, authedUser: authedUser));
        }

        return;
    }

    utilMixinSetState(() {
      _isRegistrationInProgress = false;
      utilMixinSomethingWentWrongMessage();
    });
  }
}
