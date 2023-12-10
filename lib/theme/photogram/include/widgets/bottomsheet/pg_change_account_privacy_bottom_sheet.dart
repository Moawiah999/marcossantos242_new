import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';

class PgChangeAccountPrivacyBottomSheet extends StatefulWidget {
  final void Function(String metaIsPrivate) handlerSetMetaIsPrivate;

  const PgChangeAccountPrivacyBottomSheet({
    Key? key,
    required this.handlerSetMetaIsPrivate,
  }) : super(key: key);

  @override
  _PgChangeAccountPrivacyBottomSheetState createState() => _PgChangeAccountPrivacyBottomSheetState();
}

class _PgChangeAccountPrivacyBottomSheetState extends State<PgChangeAccountPrivacyBottomSheet>
    with AppActiveContentInfiniteMixin, AppUtilsMixin {
  late UserModel _authedUserModel;

  @override
  void onLoadEvent() {
    _authedUserModel = activeContent.authBloc.getCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeBloc.colorScheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              height: 6,
              width: 44,
              margin: const EdgeInsets.only(top: 12),
              decoration: ShapeDecoration(
                color: ThemeBloc.colorScheme.onBackground.withOpacity(0.1),
                shape: const StadiumBorder(),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: ThemeBloc.textInterface.boldBlackH4Text(
                  text: _authedUserModel.isPrivateAccount
                      ? AppLocalizations.of(context)!.switchToPublicAccountQuestion
                      : AppLocalizations.of(context)!.switchToPrivateAccountQuestion),
            ),
          ),
          ThemeBloc.widgetInterface.divider(),
          Expanded(
            child: ListView(
              children: _buildListViewContent(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildListViewContent() {
    if (_authedUserModel.isPrivateAccount) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            minLeadingWidth: 25,
            leading: Icon(
              Icons.photo_outlined,
              size: 20,
              color: ThemeBloc.colorScheme.onBackground,
            ),
            title: ThemeBloc.textInterface.normalGreyH5Text(
              text: AppLocalizations.of(context)!.publicAccountBulletPointOne,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            minLeadingWidth: 25,
            leading: Icon(
              Icons.checklist_outlined,
              size: 20,
              color: ThemeBloc.colorScheme.onBackground,
            ),
            title: ThemeBloc.textInterface.normalGreyH5Text(
              text: AppLocalizations.of(context)!.publicAccountBulletPointThree,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
          child: ThemeBloc.widgetInterface.themeButton(
            text: AppLocalizations.of(context)!.switchToPublic,
            onTapCallback: () {
              widget.handlerSetMetaIsPrivate(UserEnum.metaIsPrivateNo);
              AppNavigation.pop();
            },
          ),
        ),
      ];
    }

    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          minLeadingWidth: 25,
          leading: Icon(
            Icons.photo_outlined,
            size: 20,
            color: ThemeBloc.colorScheme.onBackground,
          ),
          title: ThemeBloc.textInterface.normalGreyH5Text(
            text: AppLocalizations.of(context)!.privateAccountBulletPointOne,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          minLeadingWidth: 25,
          leading: Icon(
            Icons.comment_outlined,
            size: 20,
            color: ThemeBloc.colorScheme.onBackground,
          ),
          title: ThemeBloc.textInterface.normalGreyH5Text(
            text: AppLocalizations.of(context)!.privateAccountBulletPointTwo,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
        child: ThemeBloc.widgetInterface.themeButton(
          text: AppLocalizations.of(context)!.switchToPrivate,
          onTapCallback: () {
            widget.handlerSetMetaIsPrivate(UserEnum.metaIsPrivateYes);
            AppNavigation.pop();
          },
        ),
      ),
    ];
  }
}
