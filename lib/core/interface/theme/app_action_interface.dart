import 'package:photogram/import/core.dart';

abstract class AppActionInterface {
  abstract OpenPageUsingUserIdSignature openProfilePage;
  abstract OpenPageUsingUserIdSignature openEditProfilePage;

  abstract ShowMessageInsidePopUpSignature showMessageInsidePopUp;
}
