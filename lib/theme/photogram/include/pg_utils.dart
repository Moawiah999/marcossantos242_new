import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class PgUtils {
  static void showMessageInsidePopUp({
    Key? key,
    bool waitForFrame = false,
    required BuildContext context,
    required String message,
  }) {
    PgUtils.showPopUpWithOptions(
      key: key,
      waitForFrame: waitForFrame,
      context: context,
      options: [
        PgUtils.popUpOption(content: message, buildContext: context),
      ],
      addOkButton: true,
      addCancelButton: false,
    );
  }

  static bool openProfilePage(BuildContext? buildContext, int userId, void Function() refreshCallback) {
    return AppNavigation.push(
      buildContext,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.profilePage(userId: userId),
      ),
      refreshCallback,
    );
  }

  static bool openPendingRequestsPage(BuildContext? buildContext, void Function() refreshCallback) {
    return AppNavigation.push(
      buildContext,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.pendingFollowRequestsPage(),
      ),
      refreshCallback,
    );
  }

  static bool openPostPage(BuildContext? buildContext, int postId, void Function() refreshCallback) {
    return AppNavigation.push(
      buildContext,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.postPage(postId: postId),
      ),
      refreshCallback,
    );
  }

  static bool openRegistrationPage(BuildContext? buildContext, void Function() refreshCallback) {
    return AppNavigation.push(
      buildContext,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.registrationPage(),
      ),
      refreshCallback,
    );
  }

  static bool openRecoverAccountPage(BuildContext? buildContext, void Function() refreshCallback) {
    return AppNavigation.push(
      buildContext,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.recoverAccountPage(),
      ),
      refreshCallback,
    );
  }

  static bool openCreatePostPage(void Function() refreshCallback) {
    return AppNavigation.push(
      null,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.createPostPage(),
      ),
      refreshCallback,
    );
  }

  static bool openActivityPage(void Function() refreshCallback) {
    return AppNavigation.push(
      null,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.activityPage(),
      ),
      refreshCallback,
    );
  }

  static bool openHashtagPage(
    BuildContext? buildContext,
    int hashtagId,
    String hashtag,
    void Function() refreshCallback,
  ) {
    return AppNavigation.push(
      buildContext,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.hashtagPage(
          hashtagId: hashtagId,
          hashtag: hashtag,
        ),
      ),
      refreshCallback,
    );
  }

  static bool openEditProfilePage(BuildContext buildContext, int userId, void Function() refreshCallback) {
    return AppNavigation.push(
      buildContext,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.editProfilePage(userId: userId),
      ),
      refreshCallback,
    );
  }

  static bool openPostlikesPage(BuildContext context, int postId, void Function() refreshCallback) {
    return AppNavigation.push(
      context,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.postLikesPage(postId: postId),
      ),
      refreshCallback,
    );
  }

  static bool openPostcommentsPage({
    required BuildContext context,
    required int postId,
    bool focus = false,
    int? postCommentId,
    required void Function() refreshCallback,
  }) {
    return AppNavigation.push(
      context,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.postCommentsPage(postId: postId, focus: focus),
      ),
      refreshCallback,
    );
  }

  static bool openPostCommentLikesPage(BuildContext context, int postCommentId, void Function() refreshCallback) {
    return AppNavigation.push(
      context,
      MaterialPageRoute(
        builder: (_) => ThemeBloc.pageInterface.postCommentLikesPage(postCommentId: postCommentId),
      ),
      refreshCallback,
    );
  }

  static void openApiDocument(
    BuildContext? buildContext,
    String documentName,
  ) {
    launch('${APP_SERVER_URL}api/$documentName.php');
  }

  static Widget whiteCupertinoActivityIndicator() {
    return Theme(
        data: ThemeData(cupertinoOverrideTheme: const CupertinoThemeData(brightness: Brightness.dark)),
        child: const CupertinoActivityIndicator());
  }

  static Widget darkCupertinoActivityIndicator() {
    return const CupertinoActivityIndicator();
  }

  static Widget gridImagePreloader() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
    );
  }

  static Widget gridImageStationary() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[300],
    );
  }

  static Widget circularImageStationary() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
      width: double.infinity,
      height: double.infinity,
    );
  }

  static Widget gridImagePreloaderFull(int axisCount) {
    return GridView.builder(
      itemCount: axisCount,
      itemBuilder: (context, index) => gridImagePreloader(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: axisCount,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
    );
  }

  static Widget postContentIcon() {
    return Positioned(
      top: 10,
      right: 10,
      child: Opacity(
        opacity: 0.6,
        child: Icon(
          Icons.my_library_books_rounded,
          size: 20,
          color: ThemeBloc.colorScheme.background,
        ),
      ),
    );
  }

  static Widget flex(int size) {
    return Flexible(
      child: Container(),
      flex: size,
    );
  }

  static Widget sizedBoxH(double size) {
    return SizedBox(
      height: size,
    );
  }

  static Widget sizedBoxW(double size) {
    return SizedBox(
      width: size,
    );
  }

  static Widget appBarTextAction(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      child: ThemeBloc.textInterface.normalThemeH3Text(
        text: text,
      ),
    );
  }

  static void showPopUpWithOptions({
    Key? key,
    bool waitForFrame = false,
    required BuildContext context,
    required List<Widget> options,
    bool addOkButton = false,
    bool addCancelButton = true,
  }) {
    // add ok button
    if (addOkButton) {
      options.add(
        popUpOption(
          buildContext: context,
          key: KeyGen.from(AppWidgetKey.okMessageDialog),
          content: AppLocalizations.of(context)!.ok,
        ),
      );
    }

    // add cancel option
    if (addCancelButton) {
      options.add(
        popUpOption(
          buildContext: context,
          key: KeyGen.from(AppWidgetKey.cancelMessageDialog),
          content: AppLocalizations.of(context)!.cancel,
        ),
      );
    }

    void showPopUp() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            key: key,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: SizedBox(
              width: MediaQuery.of(context).size.width / 0.7,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) => options[index],
                separatorBuilder: (context, index) => ThemeBloc.widgetInterface.divider(),
              ),
            ),
          );
        },
      );
    }

    if (waitForFrame && WidgetsBinding.instance != null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        showPopUp();
      });
    } else {
      showPopUp();
    }
  }

  static Widget popUpOption({
    Key? key,
    required String content,
    required BuildContext buildContext,
    bool isDanger = false,
    Function? onTap,
  }) {
    return GestureDetector(
      key: key,
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
        AppNavigation.popFromRoot(buildContext);
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Text(
            content,
            style: isDanger
                ? Theme.of(buildContext).textTheme.subtitle2?.copyWith(
                      color: Theme.of(buildContext).errorColor,
                    )
                : Theme.of(buildContext).textTheme.subtitle2,
          ),
        ),
      ),
    );
  }

  static Widget fieldViewHref({
    required BuildContext context,
    required String screenTitle,
    required String screenDescription,
    required String fieldDefaultValue,
    required String fieldPlaceholderText,
    required FormEditorType formEditorType,
    int maxLines = 1,
    required Key key,
    required void Function() refreshCallback,
  }) {
    return GestureDetector(
      key: key,
      onTap: () {
        AppNavigation.push(
          context,
          MaterialPageRoute(builder: (context) {
            return ThemeBloc.pageInterface.formEditorPage(
              formEditorType: formEditorType,
              screenDescription: screenDescription,
              screenTitle: screenTitle,
            );
          }),
          refreshCallback,
        );
      },
      child: AbsorbPointer(
        absorbing: true,
        child: TextField(
          maxLines: maxLines,
          style: ThemeBloc.getThemeData.textTheme.headline5,
          controller: TextEditingController()..text = fieldDefaultValue,
          decoration: InputDecoration(
            labelText: fieldPlaceholderText,
            labelStyle: ThemeBloc.getThemeData.textTheme.caption,
          ),
        ),
      ),
    );
  }

  static String random([int length = 6]) => String.fromCharCodes(Iterable.generate(
      length,
      (_) => 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890'
          .codeUnitAt((Random()).nextInt('AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890'.length))));
}
