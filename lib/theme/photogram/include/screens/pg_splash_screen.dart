import 'package:flutter/material.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';

class PgSplashScreen extends SplashScreen {
  const PgSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    () async {
      ThemeBloc.of(context).pushEvent(ThemeEventSetFromLocalRepo(context));
      await Future.delayed(const Duration(seconds: 3));
      AuthBloc.of(context).pushEvent(AuthEventLoginFromLocalRepo(context));
    }();

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(),
            logoContainer(),
            const Spacer(),
            companyLogoContainer(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget logoContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Image.asset(
              'assets/png/Spalhe.png',
              height: 50,
              color: ThemeBloc.colorScheme.onBackground,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Image.asset(
                'assets/png/color_spalhe.png',
                height: 9,
              ),
            ),
          ],
        ),
        // SvgPicture.asset(
        //   AppIcons.logo,
        //   height: 80,
        //   color: ThemeBloc.colorScheme.onBackground,
        // )
      ],
    );
  }

  Widget companyLogoContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          ThemeBloc.getThemeMode != AppThemeMode.dark
              ? AppImages.logoCompanyOnDark
              : AppImages.logoCompanyOnLight,
          width: 120,
        ),
      ],
    );
  }
}
