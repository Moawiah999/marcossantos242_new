import 'package:flutter/material.dart';
import 'package:photogram/core/bloc/theme/theme_bloc.dart';
import 'package:photogram/import/theme.dart';

class PgWidgetModule {
  PhotogramTheme photogramTheme;
  PgWidgetModule(this.photogramTheme);

  Divider divider() => const Divider(height: 0.8);

  Widget hollowButton({
    Key? key,
    required String text,
    required Function onTapCallback,
  }) =>
      OutlinedButton(
        key: key,
        onPressed: () => onTapCallback(),
        style: OutlinedButton.styleFrom(
          alignment: Alignment.center,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        ),
        child: Text(
          text,
          style: photogramTheme.modeImplementation.hollowButtonFontStyle,
        ),
      );

  Widget themeButton({
    Key? key,
    required String text,
    required Function onTapCallback,
  }) =>
      ElevatedButton(
        key: key,
        onPressed: () => onTapCallback(),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          minimumSize: Size.zero,
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          primary: Color(0xff7833E8),
        ),
        child: Text(
          text,
          style: photogramTheme.modeImplementation.themeButtonFontStyle,
        ),
      );

  TextField standardTextField({
    Key? key,
    required BuildContext context,
    Widget? label,
    String? hintText,
    String? errorText,
    FocusNode? focusNode,
    Widget? prefixIcon,
    bool? obscureText,
    InputBorder? border,
    TextEditingController? controller,
  }) {
    return TextField(
      key: key,
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        label: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
        errorText: errorText,
        errorStyle: ThemeBloc.textInterface.normalThemeH6TextStyle().copyWith(
              color: ThemeBloc.getThemeData.errorColor,
            ),
        border: border,
        prefixIconConstraints: const BoxConstraints(
          maxHeight: 40,
          minHeight: 40,
          minWidth: 40,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      ),
    );
  }

  TextField primaryTextField({
    Key? key,
    required BuildContext context,
    Widget? label,
    String? hintText,
    String? errorText,
    FocusNode? focusNode,
    Widget? prefixIcon,
    bool? obscureText,
    InputBorder? border,
    TextEditingController? controller,
  }) {
    return TextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        label: label,
        hintText: hintText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        hintStyle: ThemeBloc.textInterface.normalGreyH6TextStyle(),
        prefixIconConstraints: const BoxConstraints(
          maxHeight: 40,
          minHeight: 40,
          minWidth: 40,
        ),
        border: border ??
            const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      ),
    );
  }
}
