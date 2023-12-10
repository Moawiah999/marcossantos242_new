import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pages/post/create/pg_create_post_add_location.dart.dart';
import 'package:photogram/theme/photogram/include/pages/post/create/pg_create_post_content_picker.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:sprintf/sprintf.dart';

class PgCreatePostPage extends CreatePostPage {
  const PgCreatePostPage({
    Key? key,
  }) : super(key: key);

  @override
  _PgCreatePostPageState createState() => _PgCreatePostPageState();
}

class _PgCreatePostPageState extends State<PgCreatePostPage> with AppActiveContentMixin, AppUtilsMixin {
  final _images = <PostContentImage>[];

  final _textEditingController = TextEditingController();
  final _scrollController = ScrollController();

  var _postDisplayLocation = '';

  var _lastError = '';
  var _isPostSubmitUnderProgress = false;

  @override
  void onDisposeEvent() {
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.createPost),
      actions: [
        GestureDetector(
          onTap: _submitPost,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: ThemeBloc.textInterface.normalThemeH3Text(
              text: _isPostSubmitUnderProgress
                  ? AppLocalizations.of(context)!.posting
                  : AppLocalizations.of(context)!.post,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: IgnorePointer(
        ignoring: _isPostSubmitUnderProgress,
        child: Column(
          children: [
            if (_lastError.isNotEmpty) _buildErrorMessage(),
            _buildPostInput(),
            ThemeBloc.widgetInterface.divider(),
            _buildPostTaggedUsersCount(),
            ThemeBloc.widgetInterface.divider(),
            _buildPostLocationHref(),
            ThemeBloc.widgetInterface.divider(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        _lastError,
        style: ThemeBloc.textInterface.normalBlackH5TextStyle().copyWith(color: ThemeBloc.colorScheme.error),
      ),
    );
  }

  Widget _buildPostTaggedUsersCount() {
    return GestureDetector(
      onTap: _openContentEditor,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ThemeBloc.textInterface.normalBlackH4Text(text: AppLocalizations.of(context)!.tagPeople),
            _buildTotalPeopleTagCounter(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostLocationHref() {
    return GestureDetector(
      onTap: _openLocationEditor,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_postDisplayLocation.isEmpty)
              ThemeBloc.textInterface.normalBlackH4Text(text: AppLocalizations.of(context)!.addLocation)
            else
              ThemeBloc.textInterface.normalThemeH4Text(text: _postDisplayLocation),
            if (_postDisplayLocation.isNotEmpty)
              GestureDetector(
                onTap: () => utilMixinSetState(() => _postDisplayLocation = ''),
                child: Icon(Icons.close, color: ThemeBloc.colorScheme.primary, size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPeopleTagCounter() {
    var totalPeopleTagged = 0;

    for (var image in _images) {
      totalPeopleTagged += image.usersTagged.length;
    }

    if (0 == totalPeopleTagged) {
      return AppUtils.nothing();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ThemeBloc.colorScheme.onBackground.withOpacity(0.4),
      ),
      child: Text(
        totalPeopleTagged.toString(),
        style: ThemeBloc.textInterface.boldBlackH5TextStyle().copyWith(
              color: ThemeBloc.colorScheme.onPrimary,
            ),
      ),
    );
  }

  Widget _buildPostInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            activeContent.authBloc.getCurrentUser.image,
          ),
          backgroundColor: Colors.grey[300],
        ),
        title: _buildPostInputTextField(),
        trailing: GestureDetector(
          onTap: _openContentEditor,
          child: _buildPostInputPhotosIcon(),
        ),
      ),
    );
  }

  Widget _buildPostInputTextField() {
    return TextField(
      key: KeyGen.from(AppWidgetKey.addCommentPostCommentsPageTextField),
      maxLines: 8,
      minLines: 1,
      controller: _textEditingController,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: AppLocalizations.of(context)!.writeACaption,
        isDense: true,
      ),
    );
  }

  Widget _buildPostInputPhotosIcon() {
    if (_images.isNotEmpty) {
      return SizedBox(
        height: 50,
        width: 50,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.memory(
                    _images.first.getImageBytes,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeBloc.colorScheme.onBackground.withOpacity(0.4),
                ),
                child: Text(
                  _images.length.toString(),
                  style: ThemeBloc.textInterface.boldBlackH3TextStyle().copyWith(
                        color: ThemeBloc.colorScheme.onPrimary,
                      ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Icon(
        Icons.add_photo_alternate_outlined,
        size: 25,
        color: ThemeBloc.colorScheme.onBackground,
      ),
    );
  }

  Future<void> _openContentEditor() async {
    utilMixinSetState(() => _lastError = '');

    var images = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PgCreatePostContentPicker(images: _images),
      ),
    );

    // only if user clicked save button on picker page
    if (images is List<PostContentImage>) {
      utilMixinSetState(() {
        _images.clear();
        _images.addAll(images);
      });
    }
  }

  Future<void> _openLocationEditor() async {
    utilMixinSetState(() => _lastError = '');

    var location = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PgCreatePostAddLocation(postLocation: _postDisplayLocation),
      ),
    );

    if (location is String) {
      utilMixinSetState(() => _postDisplayLocation = location);
    }
  }

  void _showError(String message) {
    utilMixinSetState(() {
      _lastError = message;
      _isPostSubmitUnderProgress = false;
    });
  }

  Future<void> _submitPost() async {
    if (_isPostSubmitUnderProgress) return;

    utilMixinSetState(() {
      _lastError = '';
      _isPostSubmitUnderProgress = true;
    });

    var displayCaption = _textEditingController.value.text;
    var displayLocation = _postDisplayLocation;

    var responseModel = await activeContent.apiRepository.postActionAdd(
      postDisplayCaption: displayCaption,
      postDisplayLocation: displayLocation,
      images: _images,
    );

    switch (responseModel.message) {
      case D_ERROR_POST_DISPLAY_CONTENT_ITEM_FILE_SIZE_MSG:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostDisplayContentItemSize,
            [
              AppSettings.getString(SETTING_MAX_USER_DISPLAY_IMAGE_FILE_SIZE),
            ],
          ),
        );
        break;
      case D_ERROR_POST_DISPLAY_CONTENT_ITEM_FILE_FORMAT_MSG:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostDisplayContentItemFormat,
            [
              AppSettings.getString(SETTING_SUPPORTED_USER_DISPLAY_IMAGE_FILE_FORMAT),
            ],
          ),
        );
        break;

      case D_ERROR_POST_DISPLAY_CAPTION_MAX_LEN_MSG:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostDisplayCaptionMaxLength,
            [
              AppSettings.getString(SETTING_MAX_LEN_POST_DISPLAY_CAPTION),
            ],
          ),
        );
        break;
      case D_ERROR_POST_DISPLAY_CAPTION_MIN_LEN_MSG:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostDisplayCaptionMinLength,
            [
              AppSettings.getString(SETTING_MIN_LEN_POST_DISPLAY_CAPTION),
            ],
          ),
        );
        break;

      case D_ERROR_POST_DISPLAY_LOCATION_MAX_LEN_MSG:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostDisplayLocationMaxLength,
            [
              AppSettings.getString(SETTING_MAX_LEN_POST_DISPLAY_LOCATION),
            ],
          ),
        );
        break;
      case D_ERROR_POST_DISPLAY_LOCATION_MIN_LEN_MSG:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostDisplayLocationMinLength,
            [
              AppSettings.getString(SETTING_MIN_LEN_POST_DISPLAY_LOCATION),
            ],
          ),
        );
        break;

      case D_ERROR_POST_DISPLAY_CONTENT_ITEM_MAX_MSG:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostDisplayContentItemMaxAllowed,
            [
              AppSettings.getString(SETTING_MAX_POST_DISPLAY_CONTENT_ITEM),
            ],
          ),
        );
        break;
      case D_ERROR_POST_DISPLAY_CONTENT_ITEM_MIN_MSG:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostDisplayContentItemMinAllowed,
            [
              AppSettings.getString(SETTING_MIN_POST_DISPLAY_CONTENT_ITEM),
            ],
          ),
        );
        break;

      case D_ERROR_POST_HASHTAG_MAX_MSG:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostHashtagMaxAllowed,
            [
              AppSettings.getString(SETTING_MAX_POST_HASHTAG),
            ],
          ),
        );
        break;
      case D_ERROR_POST_HASHTAG_MIN_MSG:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostHashtagMinAllowed,
            [
              AppSettings.getString(SETTING_MIN_POST_HASHTAG),
            ],
          ),
        );
        break;

      case D_ERROR_POST_HASHTAG_MAX_LEN_MSG:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostHashtagMaxLength,
            [
              AppSettings.getString(SETTING_MAX_LEN_POST_HASHTAG),
            ],
          ),
        );
        break;
      case D_ERROR_POST_HASHTAG_MIN_LEN_MSG:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostHashtagMinLength,
            [
              AppSettings.getString(SETTING_MIN_LEN_POST_HASHTAG),
            ],
          ),
        );
        break;

      case D_ERROR_POST_USER_TAG_PER_ITEM_MAX:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostUserTagPerItemMaxAllowed,
            [
              AppSettings.getString(SETTING_MAX_POST_USER_TAG_PER_ITEM),
            ],
          ),
        );
        break;
      case D_ERROR_POST_USER_TAG_PER_ITEM_MIN:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostUserTagPerItemMinAllowed,
            [
              AppSettings.getString(SETTING_MIN_POST_USER_TAG_PER_ITEM),
            ],
          ),
        );
        break;

      case D_ERROR_POST_USER_TAG_TOTAL_MAX:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostUserTagTotalMaxAllowed,
            [
              AppSettings.getString(SETTING_MAX_POST_USER_TAG_TOTAL),
            ],
          ),
        );
        break;
      case D_ERROR_POST_USER_TAG_TOTAL_MIN:
        _showError(
          sprintf(
            AppLocalizations.of(context)!.fieldErrorPostUserTagTotalMinAllowed,
            [
              AppSettings.getString(SETTING_MIN_POST_USER_TAG_TOTAL),
            ],
          ),
        );
        break;

      case SUCCESS_MSG:
        AppNavigation.pop();
        PgUtils.openProfilePage(null, activeContent.authBloc.getCurrentUser.intId, () {});
        break;

      default:
        utilMixinSetState(() => _isPostSubmitUnderProgress = false);
        return utilMixinSomethingWentWrongMessage();
    }
  }
}
