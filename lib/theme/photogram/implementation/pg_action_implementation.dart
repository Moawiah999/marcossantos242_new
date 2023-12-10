import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';

class PgActionImplementation extends AppActionInterface {
  PgActionImplementation({
    required this.openProfilePage,
    required this.openEditProfilePage,
    required this.showMessageInsidePopUp,
  });

  @override
  ShowMessageInsidePopUpSignature showMessageInsidePopUp;

  @override
  OpenPageUsingUserIdSignature openEditProfilePage;

  @override
  OpenPageUsingUserIdSignature openProfilePage;
}
