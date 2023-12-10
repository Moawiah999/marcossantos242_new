import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/pg_data_utils.dart';

class PgEmailVerificationScreen extends EmailVerificationScreen {
  const PgEmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<PgEmailVerificationScreen> createState() => _PgEmailVerificationScreenState();
}

class _PgEmailVerificationScreenState extends State<PgEmailVerificationScreen>
    with AppActiveContentMixin, AppUtilsMixin {
  late UserModel _authedUserModel;

  final _otpTextFieldController = TextEditingController();

  var _userEmailVerificationModel = UserEmailVerificationModel.none();

  var _isOnOTPVerificationPage = false;

  var _isOTPSendInProgress = false;
  var _isOTPVerificationInProgress = false;

  @override
  void onLoadEvent() {
    _authedUserModel = AuthBloc.of(context).getCurrentUser;
  }

  @override
  void onDisposeEvent() {
    _otpTextFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.emailVerification),
        leading: GestureDetector(
          onTap: () {
            AuthBloc.of(context).pushEvent(AuthEventLogout(context));
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: _isOnOTPVerificationPage ? _buildOTPVerificationSection() : _buildSendOTPSection(),
          ),
        ),
      ),
    );
  }

  Widget _buildSendOTPSection() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: IgnorePointer(
        ignoring: _isOTPSendInProgress,
        child: Column(
          children: [
            PgUtils.sizedBoxH(40),
            const Icon(Icons.mail_outline),
            PgUtils.sizedBoxH(10),
            Text(
              AppLocalizations.of(context)!.verifyEmail,
              style: ThemeBloc.textInterface.boldBlackH2TextStyle(),
              textAlign: TextAlign.center,
            ),
            PgUtils.sizedBoxH(10),
            Text(
              AppLocalizations.of(context)!.weWillSendYouAVerficationCodeOnEmail,
              style: ThemeBloc.textInterface.normalGreyH5TextStyle(),
              textAlign: TextAlign.center,
            ),
            PgUtils.sizedBoxH(20),
            SizedBox(
              width: double.infinity,
              child: ThemeBloc.widgetInterface.themeButton(
                text: _isOTPSendInProgress
                    ? AppLocalizations.of(context)!.sending
                    : AppLocalizations.of(context)!.sendCodeToMyEmail,
                onTapCallback: _sendOTP,
              ),
            ),
            PgUtils.sizedBoxH(80),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPVerificationSection() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: IgnorePointer(
        ignoring: _isOTPVerificationInProgress,
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
                text: _isOTPVerificationInProgress
                    ? AppLocalizations.of(context)!.confirming
                    : AppLocalizations.of(context)!.confirm,
                onTapCallback: _verifyOTP,
              ),
            ),
            PgUtils.sizedBoxH(80),
          ],
        ),
      ),
    );
  }

  void _sendOTP() async {
    if (_isOTPSendInProgress) return;

    utilMixinSetState(() {
      _isOTPSendInProgress = true;
    });

    var responseModel = await activeContent.apiRepository.preparedRequest(
      requestType: REQ_TYPE_USER_EMAIL_VERIFICATION_START,
      requestData: {
        UserTable.tableName: {UserTable.id: _authedUserModel.intId}
      },
    );

    if (responseModel.isResponse && SUCCESS_MSG == responseModel.message) {
      var userEmailVerificationModel = PgDataUtils.userEmailVerificationModelFromResponse(responseModel);

      if (userEmailVerificationModel.isModel) {
        _userEmailVerificationModel = userEmailVerificationModel;

        utilMixinSetState(() {
          _isOTPSendInProgress = true;
          _isOnOTPVerificationPage = true;
        });

        return;
      }
    }

    utilMixinSetState(() {
      _isOTPSendInProgress = false;
      utilMixinSomethingWentWrongMessage();
    });
  }

  void _verifyOTP() async {
    if (_isOTPVerificationInProgress) return;

    utilMixinSetState(() {
      _isOTPVerificationInProgress = true;
    });

    var responseModel = await activeContent.apiRepository.preparedRequest(
      requestType: REQ_TYPE_USER_EMAIL_VERIFICATION_CONFIRM,
      requestData: {
        UserEmailVerificationTable.tableName: {
          UserEmailVerificationTable.id: _userEmailVerificationModel.intId,
          UserEmailVerificationTable.metaAccessOTP: _otpTextFieldController.value.text,
        },
      },
    );

    switch (responseModel.message) {
      case D_ERROR_OTP_EXPIRED:
        return utilMixinSetState(() {
          _isOTPVerificationInProgress = false;
          utilMixinShowMessage(AppLocalizations.of(context)!.verificationSessionHasBeenExpired);
        });

      case D_ERROR_OTP_MISMATCH:
        return utilMixinSetState(() {
          _isOTPVerificationInProgress = false;
          utilMixinShowMessage(AppLocalizations.of(context)!.enteredOtpDoesntMatchTryAgain);
        });

      case SUCCESS_MSG:
        var userModel = PgDataUtils.userModelFromResponse(responseModel);

        if (userModel.isModel) {
          activeContent.authBloc.pushEvent(AuthEventSetAuthedUser(context, authedUser: userModel));
          return;
        }

        break;
    }

    utilMixinSetState(() {
      _isOTPVerificationInProgress = false;
      utilMixinSomethingWentWrongMessage();
    });
  }
}
