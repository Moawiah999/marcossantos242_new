import 'package:tuple/tuple.dart';

class AppIcons {
  static const logo = 'assets/svg/logo.svg';
  static const logoPng = 'assets/png/logo.png';

  // bottom navigation - start
  static const appBarCreatePost = 'assets/svg/camera_icon.svg';

  static const bottomNavHome = 'assets/svg/bottom_nav/home_icon.svg';
  static const bottomNavHomeActive = 'assets/svg/bottom_nav/home_active_icon.svg';

  static const bottomNavSearch = 'assets/svg/bottom_nav/search_icon.svg';
  static const bottomNavSearchActive = 'assets/svg/bottom_nav/search_active_icon.svg';

  static const bottomNavCreatePost = 'assets/svg/bottom_nav/upload_icon.svg';
  static const bottomNavCreatePostActive = 'assets/svg/bottom_nav/upload_active_icon.svg';

  static const bottomNavFavorite = 'assets/svg/bottom_nav/love_icon.svg';
  static const bottomNavFavoriteActive = 'assets/svg/bottom_nav/love_active_icon.svg';

  static const bottomNavAccount = 'assets/svg/bottom_nav/account_icon.svg';
  static const bottomNavAccountActive = 'assets/svg/bottom_nav/account_active_icon.svg';

  static const bottomTabIcons = [
    Tuple2(bottomNavHome, bottomNavHomeActive),
    Tuple2(bottomNavSearch, bottomNavSearchActive),
    Tuple2(bottomNavCreatePost, bottomNavCreatePostActive),
    Tuple2(bottomNavFavorite, bottomNavFavoriteActive),
    Tuple2(bottomNavAccount, bottomNavAccountActive),
  ];
}
