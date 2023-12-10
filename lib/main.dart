import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:photogram/core/app.dart';
import 'package:photogram/import/core.dart';

void main() async {
  /*
  |--------------------------------------------------------------------------
  | override global http
  |--------------------------------------------------------------------------
  */

  HttpOverrides.global = AppHttpOverrides();

  /*
  |--------------------------------------------------------------------------
  | ensure widget binding is ready
  |--------------------------------------------------------------------------
  */

  WidgetsFlutterBinding.ensureInitialized();

  /*
  |--------------------------------------------------------------------------
  | attach cert:
  |--------------------------------------------------------------------------
  */

  if (APP_SERVER_URL.startsWith('https')) {
    ByteData data = await PlatformAssetBundle().load(
      'assets/ca/lets-encrypt-r3.pem',
    );

    SecurityContext.defaultContext.setTrustedCertificatesBytes(
      data.buffer.asUint8List(),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | run the application:
  |--------------------------------------------------------------------------
  */

  runApp(const App());
}
