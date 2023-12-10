import 'package:photogram/import/core.dart';
import 'package:photogram/import/interface.dart';

class PgWidgetImplementation extends AppWidgetInterface {
  PgWidgetImplementation({
    required this.divider,
    required this.themeButton,
    required this.hollowButton,
    required this.primaryTextField,
    required this.standardTextField,
  });

  @override
  DividerSignature divider;

  @override
  ButtonWidgetSignature hollowButton;

  @override
  ButtonWidgetSignature themeButton;

  @override
  TextFieldWidgetSignature primaryTextField;

  @override
  TextFieldWidgetSignature standardTextField;
}
