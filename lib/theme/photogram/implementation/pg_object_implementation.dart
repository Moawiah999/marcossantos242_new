import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';

class PgObjectImplementation extends AppObjectInterface {
  PgObjectImplementation({
    required this.userAppTile,
  });

  @override
  UserAppTile userAppTile;
}
