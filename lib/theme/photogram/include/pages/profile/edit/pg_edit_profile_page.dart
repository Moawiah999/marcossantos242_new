import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pages/pg_context.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/bottomsheet/pg_bottom_sheet_action.dart';

import '../../../widgets/profile/pg_profile_avatar_big.dart';

class PgEditProfilePage extends EditProfilePage {
  final int userId;

  const PgEditProfilePage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _PgEditProfilePageState createState() => _PgEditProfilePageState();
}

class _PgEditProfilePageState extends State<PgEditProfilePage> with AppActiveContentMixin, AppUtilsMixin {
  late UserModel _userModel;
  final _imagePicker = ImagePicker();
  late VoidCallback _profilePhotoBottomMenu;

  @override
  void onLoadEvent() {
    _userModel = activeContent.watch<UserModel>(widget.userId) ?? UserModel.none();
  }

  @override
  Widget build(BuildContext context) {
    if (_userModel.isNotModel) {
      return AppLogger.fail('${_userModel.runtimeType}(${widget.userId})');
    }

    _profilePhotoBottomMenu = () {
      context.showBottomSheet([
        PgBottomSheetAction(
          onTap: () {},
          title: AppLocalizations.of(context)!.changeProfilePicture,
          isHeader: true,
        ),
        PgBottomSheetAction(
          onTap: () {},
          isDivider: true,
        ),
        PgBottomSheetAction(
          onTap: () async {
            var pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

            if (null != pickedImage) {
              // pop bottom nav
              if (AppNavigation.pop()) {
                // push image editor page
                AppNavigation.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ThemeBloc.pageInterface.editProfilePicturePage(pickedImage: pickedImage),
                  ),
                  utilMixinSetState,
                );
              }
            }
          },
          iconData: Icons.upload_outlined,
          title: AppLocalizations.of(context)!.uploadPhoto,
        ),
        PgBottomSheetAction(
          onTap: () async {
            XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.camera);

            if (pickedImage != null) {
              if (AppNavigation.pop()) {
                AppNavigation.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ThemeBloc.pageInterface.editProfilePicturePage(pickedImage: pickedImage),
                  ),
                  utilMixinSetState,
                );
              }
            }
          },
          iconData: Icons.camera_alt_outlined,
          title: AppLocalizations.of(context)!.takeAPhoto,
        ),
        PgBottomSheetAction(
          iconData: Icons.delete_outline,
          title: AppLocalizations.of(context)!.removeProfilePhoto,
          isRed: true,
          // remove profile picture, tiny Bloc, just go here
          onTap: () async {
            try {
              ResponseModel responseModel = await AppProvider.of(context).apiRepo.removeUserProfilePicture(
                    userId: _userModel.id,
                  );

              // User credentials don't match
              if (responseModel.message != SUCCESS_MSG) throw Exception();

              if (!responseModel.contains(UserTable.tableName)) throw Exception();

              UserModel authedUser = UserModel.fromJson(responseModel.first(UserTable.tableName));

              // double check if user data arrived correct from api
              if (authedUser.isNotModel) throw Exception();

              WidgetsBinding.instance?.addPostFrameCallback(
                (_) => utilMixinSetState(() {
                  _userModel = authedUser;
                  activeContent.addOrUpdateModel<UserModel>(_userModel);
                  activeContent.authBloc.pushEvent(AuthEventSetAuthedUser(context, authedUser: _userModel));
                }),
              );
            } catch (e) {
              if (CLIENT_DEBUG) {
                // ignore: avoid_print
                print(e);
              }
            }

            // pop bottom sheet
            AppNavigation.pop();
          },
        ),
      ]);
    };

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(AppLocalizations.of(context)!.editProfile),
          leading: GestureDetector(
            key: KeyGen.from(AppWidgetKey.backEditProfilePageIcon),
            onTap: () => AppNavigation.pop(),
            child: const Icon(Icons.arrow_back),
          ),
          actions: [
            GestureDetector(
              key: KeyGen.from(AppWidgetKey.saveEditProfilePageIcon),
              onTap: () => AppNavigation.pop(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
              ),
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PgUtils.sizedBoxH(40),
                  GestureDetector(
                    onTap: _profilePhotoBottomMenu,
                    child: Center(child: PgProfileAvatarBig(userModel: _userModel)),
                  ),
                  PgUtils.sizedBoxH(15),
                  changeProfilePictureHref(context),
                  PgUtils.sizedBoxH(15),
                  displayNameFieldView(context, _userModel),
                  PgUtils.sizedBoxH(15),
                  usernameFieldView(context, _userModel),
                  PgUtils.sizedBoxH(15),
                  displayBioFieldView(context, _userModel),
                  PgUtils.sizedBoxH(15),
                  displayWebField(context, _userModel),
                  PgUtils.sizedBoxH(40),
                ],
              ),
            ),
            personalInformationSettingsHref(context),
            PgUtils.sizedBoxH(40),
          ],
        ),
      ),
    );
  }

  Widget personalInformationSettingsHref(BuildContext context) {
    return GestureDetector(
      key: KeyGen.from(AppWidgetKey.personalInformationEditProfilePageHref),
      onTap: () {
        AppNavigation.push(
          context,
          MaterialPageRoute(
            builder: (_) => ThemeBloc.pageInterface.editPersonalInformationPage(userId: widget.userId),
          ),
          utilMixinSetState,
        );
      },
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(width: 0.4, color: Theme.of(context).hintColor),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ThemeBloc.textInterface
              .normalThemeH5Text(text: AppLocalizations.of(context)!.personalInformationSettings),
        ),
      ),
    );
  }

  Widget changeProfilePictureHref(BuildContext context) {
    return GestureDetector(
      onTap: _profilePhotoBottomMenu,
      child:
          ThemeBloc.textInterface.normalThemeH5Text(text: AppLocalizations.of(context)!.changeProfilePicture),
    );
  }

  Widget displayNameFieldView(BuildContext context, UserModel user) {
    return PgUtils.fieldViewHref(
      context: context,
      key: KeyGen.from(AppWidgetKey.displayNameProfilePageFieldView),
      screenTitle: AppLocalizations.of(context)!.changeDisplayName,
      screenDescription: AppLocalizations.of(context)!.changeDisplayNameHint,
      fieldDefaultValue: user.displayName,
      fieldPlaceholderText: AppLocalizations.of(context)!.displayName,
      formEditorType: FormEditorTypeDisplayName(
        context: context,
        defaultValue: user.displayName,
      ),
      refreshCallback: utilMixinSetState,
    );
  }

  Widget usernameFieldView(BuildContext context, UserModel user) {
    return PgUtils.fieldViewHref(
      context: context,
      key: KeyGen.from(AppWidgetKey.usernameProfilePageFieldView),
      screenTitle: AppLocalizations.of(context)!.changeUsername,
      screenDescription: AppLocalizations.of(context)!.changeUsernameHint,
      fieldDefaultValue: user.username,
      fieldPlaceholderText: AppLocalizations.of(context)!.username,
      formEditorType: FormEditorTypeUsername(
        context: context,
        defaultValue: user.username,
      ),
      refreshCallback: utilMixinSetState,
    );
  }

  Widget displayBioFieldView(BuildContext context, UserModel user) {
    return PgUtils.fieldViewHref(
      context: context,
      maxLines: 2,
      key: KeyGen.from(AppWidgetKey.displayBioProfilePageFieldView),
      screenTitle: AppLocalizations.of(context)!.changeDisplayBio,
      screenDescription: AppLocalizations.of(context)!.changeDisplayBioHint,
      fieldDefaultValue: user.displayBio,
      fieldPlaceholderText: AppLocalizations.of(context)!.displayBio,
      formEditorType: FormEditorTypeDisplayBio(
        context: context,
        defaultValue: user.displayBio,
      ),
      refreshCallback: utilMixinSetState,
    );
  }

  Widget displayWebField(BuildContext context, UserModel user) {
    return PgUtils.fieldViewHref(
      context: context,
      key: KeyGen.from(AppWidgetKey.displayWebProfilePageFieldView),
      screenTitle: AppLocalizations.of(context)!.changeDisplayWeb,
      screenDescription: AppLocalizations.of(context)!.changeDisplayWebHint,
      fieldDefaultValue: user.displayWeb,
      fieldPlaceholderText: AppLocalizations.of(context)!.displayWeb,
      formEditorType: FormEditorTypeDisplayWeb(
        context: context,
        defaultValue: user.displayWeb,
      ),
      refreshCallback: utilMixinSetState,
    );
  }
}
