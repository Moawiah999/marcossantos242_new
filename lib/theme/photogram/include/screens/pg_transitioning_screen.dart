import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgTransitioningScreen extends TransitionScreen {
  const PgTransitioningScreen({Key? key}) : super(key: key);

  @override
  State<PgTransitioningScreen> createState() => _PgTransitioningScreenState();
}

class _PgTransitioningScreenState extends State<PgTransitioningScreen> {
  var _compatible = true;
  var _isCheckingCompatibility = false;
  late final ApiCompatibilityDTO _compatibilityDTO;

  @override
  void initState() {
    super.initState();
    _checkApiCompatibility();
  }

  @override
  Widget build(BuildContext context) {
    if (!_compatible) {
      return _buildUpdateAppScreen();
    }

    return StreamBuilder<AuthState>(
      stream: AuthBloc.of(context).stream,
      builder: (context, snapshot) {
        /// If we've checked the user credentials
        if (snapshot.hasData) {
          switch (snapshot.data.runtimeType) {
            case AuthStateLoggedOut:
              return ThemeBloc.screenInterface.loginScreen(key: KeyGen.from(AppWidgetKey.loginScreen));
            case AuthStateAuthed:
              return ThemeBloc.screenInterface.homeScreen(key: KeyGen.from(AppWidgetKey.homeScreen));
            case AuthStateRequiresEmailVerification:
              return ThemeBloc.screenInterface.emailVerificationScreen(
                key: KeyGen.from(AppWidgetKey.emailVerificationScreen),
              );
            case AuthStateNoNetwork:
              return ThemeBloc.screenInterface.noNetworkScreen(key: KeyGen.from(AppWidgetKey.noNetworkScreen));
          }

          return ThemeBloc.screenInterface
              .somethingWentWrongScreen(key: KeyGen.from(AppWidgetKey.somethingWentWrongScreen));
        } else {
          return ThemeBloc.screenInterface.splashScreen(key: KeyGen.from(AppWidgetKey.splashScreen));
        }
      },
    );
  }

  Widget _buildUpdateAppScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.updateYourApp),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Column(
                children: [
                  PgUtils.sizedBoxH(40),
                  const Icon(Icons.update_outlined),
                  PgUtils.sizedBoxH(10),
                  Text(
                    AppLocalizations.of(context)!.updateYourApp,
                    style: ThemeBloc.textInterface.boldBlackH2TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  PgUtils.sizedBoxH(10),
                  Text(
                    _compatibilityDTO.message,
                    style: ThemeBloc.textInterface.normalGreyH5TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  PgUtils.sizedBoxH(40),
                  PgUtils.sizedBoxH(20),
                  SizedBox(
                    width: double.infinity,
                    child: ThemeBloc.widgetInterface.themeButton(
                      text: AppLocalizations.of(context)!.update,
                      onTapCallback: () async {
                        var urlToLaunch =
                            (Platform.isIOS) ? _compatibilityDTO.iosUpdateUrl : _compatibilityDTO.androidUpdateUrl;

                        if (await canLaunch(urlToLaunch)) {
                          launch(urlToLaunch);
                        }
                      },
                    ),
                  ),
                  PgUtils.sizedBoxH(80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkApiCompatibility() async {
    if (_isCheckingCompatibility) return;
    _isCheckingCompatibility = true;

    var responseModel = await AppProvider.of(context).apiRepo.preparedRequest(
      requestType: REQ_TYPE_MISC_COMPATIBILITY,
      requestData: {},
    );

    if (responseModel.isResponse && responseModel.contains(ApiCompatibilityDTO.dtoName)) {
      var compatibilityDTO = ApiCompatibilityDTO.fromJson(responseModel.first(ApiCompatibilityDTO.dtoName));

      if (compatibilityDTO.isDTO && ApiCompatibilityDTO.statusRequiresUpdate == compatibilityDTO.status) {
        setState(() {
          _compatible = false;
          _compatibilityDTO = compatibilityDTO;
        });
      }
    }
  }
}
