// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:photogram/import/core.dart';
import 'package:photogram/import/theme.dart';

/*
|--------------------------------------------------------------------------
| app configuration:
|--------------------------------------------------------------------------
*/

const INSTALLATION_URL = 'https://recco.site/';

// 10.0.2.2 is localhost, leave it as it is if you're running locally(Android Emulator)

const APP_NAME = 'Recco';

/*
|--------------------------------------------------------------------------
| api version, please don't change
|--------------------------------------------------------------------------
*/

const APP_API_VERSION = '0.2';

/*
|--------------------------------------------------------------------------
| whether to log errors:
|--------------------------------------------------------------------------
*/

const CLIENT_DEBUG = false;

/*
|--------------------------------------------------------------------------
| default app page
|--------------------------------------------------------------------------
*/

var DEFAULT_NAVIGATOR_STATE = AppNavigation.feedsPageNavigator;

/*
|--------------------------------------------------------------------------
| theme related:
|--------------------------------------------------------------------------
*/

Map AVAILABLE_THEMES = {
  PhotogramTheme.title: PhotogramTheme(), //  <- first entry is default theme
};

// each theme can provide support for different modes,
// if supported not provided, theme will use standard mode(whatever it support)
const DEFAULT_THEME_MODE = AppThemeMode.dark;

const POST_TEXT_WRAP_THRESHOLD = 100;
const COMMENT_TEXT_WRAP_THRESHOLD = 150;
const COMMENT_PLACEHOLDER_TEXT_WRAP_THRESHOLD = 50;

/*
|--------------------------------------------------------------------------
| dont change below settings
|--------------------------------------------------------------------------
*/

final APP_SERVER_URL = INSTALLATION_URL.endsWith('/') ? INSTALLATION_URL : INSTALLATION_URL + '/';
