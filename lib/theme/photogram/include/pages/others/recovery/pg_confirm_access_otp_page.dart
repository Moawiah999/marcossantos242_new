import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_data_utils.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:sprintf/sprintf.dart';

class PgConfirmAccessOTPPage extends RecoverAccountPage {
  final UserRecoveryModel userRecoveryModel;

  const PgConfirmAccessOTPPage({
    Key? key,
    required this.userRecoveryModel,
  }) : super(key: key);

  @override
  State<PgConfirmAccessOTPPage> createState() => _PgConfirmCodePageState();
}

class _PgConfirmCodePageState extends State<PgConfirmAccessOTPPage> with AppActiveContentMixin, AppUtilsMixin {
  final _otpTextFieldController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();

  late UserRecoveryModel _userRecoveryModel;

  var _confirmationInProgress = false;
  var _passwordResettingInProgress = false;
  var _onChangePasswordPage = false;

  @override
  void onDisposeEvent() {
    _otpTextFieldController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.recoverAccount)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: _onChangePasswordPage ? _buildPasswordResetSection() : _buildCodeConfirmationSection(),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeConfirmationSection() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: IgnorePointer(
        ignoring: _confirmationInProgress,
        child: Column(
          children: [
            PgUtils.sizedBoxH(40),
            const Icon(Icons.password_outlined),
            PgUtils.sizedBoxH(10),
            Text(
              AppLocalizations.of(context)!.weveSentYouAnOtp,
              style: ThemeBloc.textInterface.boldBlackH2TextStyle(),
              textAlign: TextAlign.center,
            ),
            PgUtils.sizedBoxH(10),
            Text(
              AppLocalizations.of(context)!.pleaseCheckYourEmail,
              style: ThemeBloc.textInterface.normalGreyH5TextStyle(),
              textAlign: TextAlign.center,
            ),
            PgUtils.sizedBoxH(40),
            ThemeBloc.widgetInterface.primaryTextField(
              context: context,
              hintText: AppLocalizations.of(context)!.enterOtpReceived,
              controller: _otpTextFieldController,
            ),
            PgUtils.sizedBoxH(20),
            SizedBox(
              width: double.infinity,
              child: ThemeBloc.widgetInterface.themeButton(
                text: _confirmationInProgress
                    ? AppLocalizations.of(context)!.confirming
                    : AppLocalizations.of(context)!.confirm,
                onTapCallback: _confirmAccessOTP,
              ),
            ),
            PgUtils.sizedBoxH(80),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordResetSection() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: IgnorePointer(
        ignoring: _passwordResettingInProgress,
        child: Column(
          children: [
            PgUtils.sizedBoxH(40),
            const Icon(Icons.lock_open_outlined),
            PgUtils.sizedBoxH(10),
            Text(
              AppLocalizations.of(context)!.resetPassword,
              style: ThemeBloc.textInterface.boldBlackH2TextStyle(),
              textAlign: TextAlign.center,
            ),
            PgUtils.sizedBoxH(40),
            ThemeBloc.widgetInterface.primaryTextField(
              context: context,
              hintText: AppLocalizations.of(context)!.chooseAPassword,
              controller: _passwordController,
              obscureText: true,
            ),
            PgUtils.sizedBoxH(10),
            ThemeBloc.widgetInterface.primaryTextField(
              context: context,
              hintText: AppLocalizations.of(context)!.retypeNewPassword,
              controller: _retypePasswordController,
              obscureText: true,
            ),
            PgUtils.sizedBoxH(20),
            SizedBox(
              width: double.infinity,
              child: ThemeBloc.widgetInterface.themeButton(
                text: _passwordResettingInProgress
                    ? AppLocalizations.of(context)!.resetting
                    : AppLocalizations.of(context)!.resetPassword,
                onTapCallback: _resetPassword,
              ),
            ),
            PgUtils.sizedBoxH(80),
          ],
        ),
      ),
    );
  }

  void _resetPassword() async {
    if (_passwordResettingInProgress) return;

    utilMixinSetState(() {
      _passwordResettingInProgress = true;
    });

    var responseModel = await activeContent.apiRepository.preparedRequest(
      requestType: REQ_TYPE_USER_RECOVERY_RESET_PASSWORD,
      requestData: {
        UserRecoveryTable.tableName: {
          UserRecoveryTable.id: widget.userRecoveryModel.intId,
          UserRecoveryTable.metaAccessToken: _userRecoveryModel.metaAccessToken,
        },
        UserTable.tableName: {
          UserTable.extraNewPassword: _passwordController.value.text,
          UserTable.extraRetypeNewPassword: _retypePasswordController.value.text,
        }
      },
    );

    switch (responseModel.message) {
      case D_ERROR_OTP_EXPIRED:
        return utilMixinSetState(() {
          _passwordResettingInProgress = false;
          utilMixinShowMessage(AppLocalizations.of(context)!.verificationSessionHasBeenExpired);
        });

      case D_ERROR_OTP_MISMATCH:
        return utilMixinSetState(() {
          _passwordResettingInProgress = false;
          utilMixinShowMessage(AppLocalizations.of(context)!.enteredOtpDoesntMatchTryAgain);
        });

      case D_ERROR_USER_PASSWORD_MAX_LEN_MSG:
        return utilMixinSetState(() {
          _passwordResettingInProgress = false;
          utilMixinShowMessage(
            sprintf(
              AppLocalizations.of(context)!.fieldErrorUserPasswordMaxLength,
              [AppSettings.getString(SETTING_MAX_LEN_USER_PASSWORD)],
            ),
          );
        });

      case D_ERROR_USER_PASSWORD_MIN_LEN_MSG:
        return utilMixinSetState(() {
          _passwordResettingInProgress = false;
          utilMixinShowMessage(
            sprintf(
              AppLocalizations.of(context)!.fieldErrorUserPasswordMinLength,
              [AppSettings.getString(SETTING_MIN_LEN_USER_PASSWORD)],
            ),
          );
        });

      case D_ERROR_USER_PASSWORD_MISMATCH_MSG:
        return utilMixinSetState(() {
          _passwordResettingInProgress = false;
          utilMixinShowMessage(AppLocalizations.of(context)!.fieldErrorUserPasswordMismatch);
        });

      case SUCCESS_MSG:
        var userModel = PgDataUtils.userModelFromResponse(responseModel);

        if (userModel.isModel) {
          AppNavigation.pop();
          activeContent.authBloc.pushEvent(AuthEventSetAuthedUser(context, authedUser: userModel));
          return;
        }

        break;
    }

    utilMixinSetState(() {
      _passwordResettingInProgress = false;

      utilMixinSomethingWentWrongMessage();
    });
  }

  void _confirmAccessOTP() async {
    if (_confirmationInProgress) return;

    utilMixinSetState(() {
      _confirmationInProgress = true;
    });

    var responseModel = await activeContent.apiRepository.preparedRequest(
      requestType: REQ_TYPE_USER_RECOVERY_CONFIRM,
      requestData: {
        UserRecoveryTable.tableName: {
          UserRecoveryTable.id: widget.userRecoveryModel.intId,
          UserRecoveryTable.metaAccessOTP: _otpTextFieldController.value.text,
        }
      },
    );

    switch (responseModel.message) {
      case D_ERROR_OTP_EXPIRED:
        return utilMixinSetState(() {
          _confirmationInProgress = false;
          utilMixinShowMessage(AppLocalizations.of(context)!.verificationSessionHasBeenExpired);
        });

      case D_ERROR_OTP_MISMATCH:
        return utilMixinSetState(() {
          _confirmationInProgress = false;
          utilMixinShowMessage(AppLocalizations.of(context)!.enteredOtpDoesntMatchTryAgain);
        });

      case SUCCESS_MSG:
        var userRecoverModel = PgDataUtils.userRecoveryModelFromResponse(responseModel);

        if (userRecoverModel.isModel) {
          utilMixinSetState(() {
            _confirmationInProgress = false;
            _onChangePasswordPage = true;
            _userRecoveryModel = userRecoverModel;
          });

          return;
        }

        break;
    }

    utilMixinSetState(() {
      _confirmationInProgress = false;

      utilMixinSomethingWentWrongMessage();
    });
  }
}
