import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/pg_data_utils.dart';
import 'package:photogram/theme/photogram/include/pages/others/recovery/pg_confirm_access_otp_page.dart';

class PgRecoverAccountPage extends RecoverAccountPage {
  const PgRecoverAccountPage({Key? key}) : super(key: key);

  @override
  State<PgRecoverAccountPage> createState() => _PgRecoverAccountPageState();
}

class _PgRecoverAccountPageState extends State<PgRecoverAccountPage> with AppActiveContentMixin, AppUtilsMixin {
  final _usernameTextFieldController = TextEditingController();
  var _userModelToRecover = UserModel.none();

  var _findingInProgress = false;
  var _recoveryInProgress = false;

  @override
  void onDisposeEvent() {
    _usernameTextFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.recoverAccount)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: _userModelToRecover.isNotModel
                ? _buildAccountSelector()
                : (_recoveryInProgress
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: PgUtils.darkCupertinoActivityIndicator(),
                        ),
                      )
                    : _buildAccountConfirmationSection()),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSelector() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: IgnorePointer(
        ignoring: _findingInProgress,
        child: Column(
          children: [
            PgUtils.sizedBoxH(40),
            const Icon(Icons.lock_outline),
            PgUtils.sizedBoxH(10),
            Text(
              AppLocalizations.of(context)!.troubleLoggingIn,
              style: ThemeBloc.textInterface.boldBlackH2TextStyle(),
              textAlign: TextAlign.center,
            ),
            PgUtils.sizedBoxH(10),
            Text(
              AppLocalizations.of(context)!.weCanHelpYouResetYourAccountPassword,
              style: ThemeBloc.textInterface.normalGreyH5TextStyle(),
              textAlign: TextAlign.center,
            ),
            PgUtils.sizedBoxH(40),
            ThemeBloc.widgetInterface.primaryTextField(
              context: context,
              hintText: AppLocalizations.of(context)!.usernameOfYouAccount,
              controller: _usernameTextFieldController,
            ),
            PgUtils.sizedBoxH(20),
            SizedBox(
              width: double.infinity,
              child: ThemeBloc.widgetInterface.themeButton(
                text: _findingInProgress
                    ? AppLocalizations.of(context)!.finding
                    : AppLocalizations.of(context)!.findAccount,
                onTapCallback: _findAccount,
              ),
            ),
            PgUtils.sizedBoxH(80),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountConfirmationSection() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: IgnorePointer(
        ignoring: _findingInProgress,
        child: Column(
          children: [
            PgUtils.sizedBoxH(40),
            CachedNetworkImage(
              imageUrl: _userModelToRecover.image,
              imageBuilder: (context, imageProvider) {
                return CircleAvatar(backgroundImage: imageProvider);
              },
            ),
            PgUtils.sizedBoxH(10),
            Text(
              _userModelToRecover.name,
              style: ThemeBloc.textInterface.normalGreyH5TextStyle(),
              textAlign: TextAlign.center,
            ),
            PgUtils.sizedBoxH(40),
            Text(
              AppLocalizations.of(context)!.isThisYourAccount,
              style: ThemeBloc.textInterface.boldBlackH2TextStyle(),
              textAlign: TextAlign.center,
            ),
            PgUtils.sizedBoxH(20),
            SizedBox(
              width: double.infinity,
              child: ThemeBloc.widgetInterface.themeButton(
                text: AppLocalizations.of(context)!.yesRecoverThis,
                onTapCallback: _startRecovery,
              ),
            ),
            PgUtils.sizedBoxH(10),
            SizedBox(
              width: double.infinity,
              child: ThemeBloc.widgetInterface.hollowButton(
                text: AppLocalizations.of(context)!.noFindAgain,
                onTapCallback: () {
                  utilMixinSetState(() {
                    _userModelToRecover = UserModel.none();
                  });
                },
              ),
            ),
            PgUtils.sizedBoxH(80),
          ],
        ),
      ),
    );
  }

  void _findAccount() async {
    if (_findingInProgress) return;

    utilMixinSetState(() {
      _findingInProgress = true;
    });

    var responseModel =
        await activeContent.apiRepository.userByUsername(username: _usernameTextFieldController.value.text);

    var userModel = PgDataUtils.userModelFromResponse(responseModel);

    if (userModel.isModel) {
      activeContent.handleResponse(responseModel);

      // always! get model from state manager so we can stay up to date
      _userModelToRecover = activeContent.read<UserModel>(userModel.intId) ?? UserModel.none();
    }

    if (_userModelToRecover.isNotModel) {
      utilMixinSetState(() {
        _findingInProgress = false;

        ThemeBloc.actionInterface.showMessageInsidePopUp(
          context: context,
          waitForFrame: false,
          message: AppLocalizations.of(context)!.cantFindYourAccount,
        );
      });

      return;
    }

    utilMixinSetState(() {
      _findingInProgress = false;
    });
  }

  void _startRecovery() async {
    if (_recoveryInProgress) return;

    utilMixinSetState(() {
      _recoveryInProgress = true;
    });

    var responseModel = await activeContent.apiRepository.preparedRequest(
      requestType: REQ_TYPE_USER_RECOVERY_START,
      requestData: {
        UserTable.tableName: {UserTable.id: _userModelToRecover.intId}
      },
    );

    if (responseModel.isResponse && SUCCESS_MSG == responseModel.message) {
      var userRecoveryModel = PgDataUtils.userRecoveryModelFromResponse(responseModel);

      if (userRecoveryModel.isModel) {
        AppNavigation.pop();
        AppNavigation.push(
          context,
          MaterialPageRoute(
            builder: (_) => PgConfirmAccessOTPPage(userRecoveryModel: userRecoveryModel),
          ),
          utilMixinSetState,
        );

        return;
      }
    }

    utilMixinSetState(() {
      _recoveryInProgress = false;
      utilMixinSomethingWentWrongMessage();
    });
  }
}
