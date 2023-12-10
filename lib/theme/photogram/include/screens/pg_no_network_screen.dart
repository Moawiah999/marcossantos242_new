import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';

class PgNoNetworkScreen extends NoNetworkScreen {
  const PgNoNetworkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.somethingWentWrong),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Text(AppLocalizations.of(context)!.somethingWentWrongMessage),
        ),
      ),
    );
  }
}
