import 'package:flutter/material.dart';

class AppTile {
  Key? key;
  Widget? leading;
  Widget? title;
  Widget? subtitle;
  Widget? trailing;

  void Function()? onTap;

  AppTile({this.key});

  ListTile dispense() {
    return ListTile(
      key: key,
      leading: leading,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      trailing: trailing,
    );
  }
}
