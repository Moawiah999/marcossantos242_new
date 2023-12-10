import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';
import 'package:cropperx/cropperx.dart';
import 'package:image_picker/image_picker.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgEditProfilePicturePage extends EditProfilePicturePage {
  final XFile pickedImage;
  late final File _imageFile;
  final Widget loader = const Center(child: CircularProgressIndicator());

  PgEditProfilePicturePage({
    Key? key,
    required this.pickedImage,
  }) : super(key: key) {
    _imageFile = File(pickedImage.path);
  }

  @override
  _PgEditProfilePicturePageState createState() => _PgEditProfilePicturePageState();
}

class _PgEditProfilePicturePageState extends State<PgEditProfilePicturePage> with AppActiveContentMixin, AppUtilsMixin {
  final _cropperKey = GlobalKey<State<StatefulWidget>>();
  var _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(AppLocalizations.of(context)!.saveProfilePicture),
        leading: GestureDetector(
          onTap: () => AppNavigation.pop(),
          child: const Icon(Icons.arrow_back),
        ),
        actions: [
          GestureDetector(
            onTap: _uploadImage,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _isUploading
                  ? PgUtils.darkCupertinoActivityIndicator()
                  : Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Cropper(
              cropperKey: _cropperKey,
              overlayType: OverlayType.circle,
              image: Image.file(widget._imageFile),
            ),
          ),
        ],
      ),
    );
  }

  // preload switcher
  void _loading(bool preloadingState) {
    setState(() {
      _isUploading = preloadingState;
    });
  }

  void _somethingWentWrong() {
    _loading(false);

    ThemeBloc.actionInterface.showMessageInsidePopUp(
      waitForFrame: true,
      context: context,
      message: AppLocalizations.of(context)!.somethingWentWrongMessage,
    );
  }

  void _showError(String message) {
    _loading(false);

    ThemeBloc.actionInterface.showMessageInsidePopUp(
      waitForFrame: false,
      context: context,
      message: message,
    );
  }

  void _uploadImage() async {
    _loading(true);

    var imageBytes = await Cropper.crop(cropperKey: _cropperKey);

    try {
      if (imageBytes == null) throw Exception();

      var responseModel = await AppProvider.of(context).apiRepo.uploadUseProfilePicture(fileBytes: imageBytes);

      if (responseModel.isNotResponse) throw Exception();

      switch (responseModel.message) {
        case D_ERROR_USER_DISPLAY_IMAGE_FILE_SIZE_MSG:
          _showError(
            sprintf(
              AppLocalizations.of(context)!.fieldErrorUserDisplayImageSize,
              [AppSettings.getString(SETTING_MAX_USER_DISPLAY_IMAGE_FILE_SIZE)],
            ),
          );
          break;

        case D_ERROR_USER_DISPLAY_IMAGE_FILE_FORMAT_MSG:
          _showError(
            sprintf(
              AppLocalizations.of(context)!.fieldErrorUserDisplayImageFormat,
              [AppSettings.getString(SETTING_SUPPORTED_USER_DISPLAY_IMAGE_FILE_FORMAT)],
            ),
          );
          break;

        case SUCCESS_MSG:
          if (!responseModel.contains(UserTable.tableName)) throw Exception();

          var authedUser = UserModel.fromJson(responseModel.first(UserTable.tableName));

          if (authedUser.isNotModel) throw Exception();

          utilMixinSetState(() {
            activeContent.addOrUpdateModel<UserModel>(authedUser);
            activeContent.authBloc.pushEvent(AuthEventSetAuthedUser(context, authedUser: authedUser));
          });
          break;

        default:
          throw Exception();
      }
    } catch (e) {
      AppLogger.exception(e);
      return _somethingWentWrong();
    }

    // go back to edit profile page
    AppNavigation.pop();
  }
}
