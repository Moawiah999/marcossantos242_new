import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/bloc.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:sprintf/sprintf.dart';

class PgCreatePostTagPeople extends StatefulWidget {
  final PostContentImage image;

  const PgCreatePostTagPeople({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  _PgCreatePostTagPeopleState createState() => _PgCreatePostTagPeopleState();
}

class _PgCreatePostTagPeopleState extends State<PgCreatePostTagPeople>
    with AppActiveContentInfiniteMixin, AppUtilsMixin {
  late final PostContentImage _image;
  final _settingMaxAllowedTagsPerImage = AppSettings.getInt(SETTING_MAX_POST_USER_TAG_PER_ITEM);

  final _searchTextFieldFocusNode = FocusNode();
  final _searchTextFieldEditingController = TextEditingController();

  final _userIds = <int>[];

  // search related
  var _token = PgUtils.random();
  var _showSearchInputOptions = false;
  var _isSearchingFromStart = false;

  // to make it more user friendly
  var _lastSearchedValue = '';
  late Timer _searchTriggerTimer;

  var _imageWidth = .0;
  var _imageHeight = .0;

  @override
  void onLoadEvent() {
    _image = widget.image;
    _searchTextFieldEditingController.addListener(_search);
    _searchTriggerTimer = Timer(const Duration(seconds: 1), _search);
  }

  @override
  void onDisposeEvent() {
    _searchTextFieldFocusNode.dispose();
    _searchTextFieldEditingController.dispose();

    if (_searchTriggerTimer.isActive) {
      _searchTriggerTimer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    if (_showSearchInputOptions) {
      return AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: ThemeBloc.widgetInterface.primaryTextField(
          context: context,
          focusNode: _searchTextFieldFocusNode,
          controller: _searchTextFieldEditingController,
          hintText: AppLocalizations.of(context)!.search,
          prefixIcon: const Icon(Icons.search),
        ),
        actions: [
          GestureDetector(
            onTap: _cancelTaging,
            child: PgUtils.appBarTextAction(AppLocalizations.of(context)!.cancel),
          ),
        ],
      );
    }

    return AppBar(
      title: Text(_image.usersTagged.isEmpty
          ? AppLocalizations.of(context)!.clickOnImageToTagSomeone
          : AppLocalizations.of(context)!.tagPeople),
      centerTitle: false,
      actions: [
        if (_image.usersTagged.isNotEmpty)
          GestureDetector(
            onTap: _saveChanges,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              child: Icon(Icons.check, color: ThemeBloc.colorScheme.primary),
            ),
          ),
      ],
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildImage(),
                _buildTagsView(),
              ],
            ),
          ),
        ),
        if (_showSearchInputOptions && _searchTextFieldEditingController.value.text.isNotEmpty) _buildSearchResults()
      ],
    );
  }

  Widget _buildSearchResults() {
    return Positioned.fill(
      child: (_isSearchingFromStart)
          ? Container(
              color: ThemeBloc.colorScheme.background,
              child: Align(
                alignment: Alignment.center,
                child: ThemeBloc.textInterface.normalThemeH5Text(text: AppLocalizations.of(context)!.searching),
              ),
            )
          : Container(
              color: ThemeBloc.colorScheme.background,
              child: ListView.builder(
                itemCount: isLoadingBottom ? _userIds.length + 1 : _userIds.length,
                itemBuilder: _buildUser,
              ),
            ),
    );
  }

  Widget _buildUser(BuildContext context, int index) {
    if (_userIds.length - 3 < index) {
      _loadUsers(waitForFrame: true);
    }

    if (_userIds.length > index) {
      return _buildUserTile(_userIds[index]);
    }

    return PgUtils.darkCupertinoActivityIndicator();
  }

  Widget _buildUserTile(int userId) {
    var userModel = activeContent.watch<UserModel>(userId) ?? UserModel.none();

    if (userModel.isNotModel) {
      return AppLogger.fail('${userModel.runtimeType}($userId)');
    }

    return GestureDetector(
      onTap: () => _tagUserOnLocation(userModel),
      child: Container(
        padding: const EdgeInsets.only(left: 6),
        child: ListTile(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: CachedNetworkImage(
              imageUrl: userModel.image,
              imageBuilder: (context, imageProvider) {
                return CircleAvatar(backgroundImage: imageProvider);
              },
            ),
          ),
          title: ThemeBloc.textInterface.normalBlackH5Text(text: userModel.name),
          subtitle:
              userModel.displayName.isEmpty ? null : ThemeBloc.textInterface.normalGreyH5Text(text: userModel.username),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: Overlay(
        initialEntries: [
          OverlayEntry(builder: (context) {
            return Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      if (_showSearchInputOptions) return;
                    },
                    onTapDown: _tagLocation,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // update height
                        _imageHeight = _imageWidth = constraints.maxWidth;

                        return SizedBox(
                          width: double.infinity,
                          child: Image.memory(_image.getImageBytes, fit: BoxFit.cover),
                        );
                      },
                    ),
                  ),
                ),
                ..._buildPostTagSectionItems()
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTagsView() {
    if (_image.usersTagged.isEmpty) {
      return AppUtils.nothing();
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _image.usersTagged
          .map((userId, userModel) => MapEntry(
              userId,
              GestureDetector(
                onTap: () => _tagUserOnLocation(userModel),
                child: ListTile(
                  leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: CachedNetworkImage(
                      imageUrl: userModel.image,
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(backgroundImage: imageProvider);
                      },
                    ),
                  ),
                  title: ThemeBloc.textInterface.normalBlackH6Text(text: userModel.displayName),
                  subtitle: ThemeBloc.textInterface.normalGreyH6Text(text: userModel.username),
                  trailing: ThemeBloc.widgetInterface.hollowButton(
                    text: AppLocalizations.of(context)!.remove,
                    onTapCallback: () => _removeTaggedUser(userModel),
                  ),
                ),
              )))
          .values
          .toList(),
    );
  }

  List<Widget> _buildPostTagSectionItems() {
    var itemsOnStack = <Widget>[];

    if (_image.displayUserTagsOnImage.isNotEmpty) {
      for (var userTag in _image.displayUserTagsOnImage) {
        itemsOnStack.add(
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double offsetTop = (userTag.offsetTop / 100);
                double offsetLeft = (userTag.offsetLeft / 100);

                if (offsetLeft > .98) {
                  offsetLeft = 0.97;
                }

                if (offsetLeft < .01) {
                  offsetLeft = 0.02;
                }

                bool isUp = offsetLeft > .35 && offsetLeft < .65;

                return Align(
                  alignment: Alignment(-1.0 + offsetLeft * 2, -1.0 + offsetTop * 2),
                  child: SimpleTooltip(
                    show: !isLoadingCallInStack && _searchTextFieldEditingController.value.text.isEmpty,
                    borderWidth: 0,
                    borderRadius: 6,
                    arrowLength: isUp ? 4 : 10,
                    arrowBaseWidth: 8,
                    child: const SizedBox.shrink(),
                    ballonPadding: EdgeInsets.zero,
                    animationDuration: const Duration(milliseconds: 400),
                    tooltipDirection: offsetLeft > .65
                        ? TooltipDirection.left
                        : (offsetLeft < .35 ? TooltipDirection.right : TooltipDirection.up),
                    backgroundColor: ThemeBloc.colorScheme.onBackground.withOpacity(0.75),
                    content: Text(
                      userTag.username,
                      style: ThemeBloc.textInterface
                          .normalHrefH6TextStyle()
                          .copyWith(color: ThemeBloc.colorScheme.background),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    }

    return itemsOnStack;
  }

  void _tagLocation(TapDownDetails details) {
    if (_showSearchInputOptions) return;

    if (_image.displayUserTagsOnImage.length >= _settingMaxAllowedTagsPerImage) {
      ThemeBloc.actionInterface.showMessageInsidePopUp(
        context: context,
        waitForFrame: false,
        message: sprintf(
            AppLocalizations.of(context)!.fieldErrorPostUserTagPerItemMaxAllowed, [_settingMaxAllowedTagsPerImage]),
      );

      return;
    }

    var offsetTop = (details.localPosition.dy * 100 / _imageHeight).round();
    var offsetLeft = (details.localPosition.dx * 100 / _imageWidth).round();

    var dummyTag = PostDisplayUserTagDTO(
      userId: 0,
      username: AppLocalizations.of(context)!.whosThis,
      offsetTop: offsetTop,
      offsetLeft: offsetLeft,
    );

    utilMixinSetState(() {
      _showSearchInputOptions = true;
      _image.displayUserTagsOnImage.removeWhere((tag) => 0 == tag.userId);
      _image.displayUserTagsOnImage.add(dummyTag);
      _searchTextFieldFocusNode.requestFocus();
    });
  }

  void _cancelTaging() {
    _image.displayUserTagsOnImage.removeWhere((tag) => 0 == tag.userId);

    utilMixinSetState(() {
      _showSearchInputOptions = false;
    });
  }

  void _removeTaggedUser(UserModel userModel) {
    utilMixinSetState(() {
      _image.usersTagged.removeWhere((id, model) => model.username == userModel.username);
      _image.displayUserTagsOnImage.removeWhere((tag) => tag.username == userModel.username);
    });
  }

  void _tagUserOnLocation(UserModel userModel) {
    var dummyTagIndex = _image.displayUserTagsOnImage.indexWhere((tag) => 0 == tag.userId);
    var dummyTag = _image.displayUserTagsOnImage[dummyTagIndex];

    var userTag = PostDisplayUserTagDTO(
      userId: userModel.intId,
      username: userModel.username,
      offsetTop: dummyTag.offsetTop,
      offsetLeft: dummyTag.offsetLeft,
    );

    // replace tag
    _image.displayUserTagsOnImage[dummyTagIndex] = userTag;
    _image.usersTagged.addAll({userModel.intId: userModel});

    _searchTextFieldEditingController.clear();

    utilMixinSetState(() {
      _isSearchingFromStart = false;
      _showSearchInputOptions = false;
    });
  }

  Future<void> _search() async {
    if (!_showSearchInputOptions) return;

    // prevent stuttering when keyboard changes or when framework calls for rebuild
    if (_lastSearchedValue == _searchTextFieldEditingController.value.text) return;

    _registerSearchRequest();
  }

  void _registerSearchRequest() {
    // show preloader
    utilMixinSetState(() {
      _userIds.clear();

      _isSearchingFromStart = true;

      contentMixinClearState();
    });

    var requestToken = PgUtils.random();

    _token = requestToken;
    _lastSearchedValue = _searchTextFieldEditingController.value.text;

    if (_searchTriggerTimer.isActive) {
      _searchTriggerTimer.cancel();
    }

    _searchTriggerTimer = Timer(const Duration(seconds: 2), () => _performSearchRequest(requestToken));
  }

  Future<void> _performSearchRequest(String requestToken) async {
    // check token before doing request
    if (_token != requestToken) return;

    if (_searchTextFieldEditingController.value.text.isEmpty) return;

    _loadUsers(latest: true);
  }

  Future<void> _loadUsers({bool latest = false, bool waitForFrame = false}) async {
    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_USER_GLOBAL_SEARCH_LATEST,
      bottomEndpoint: REQ_TYPE_USER_GLOBAL_SEARCH_BOTTOM,
      requestDataGenerator: () => {
        UserTable.tableName: {UserTable.displayName: _searchTextFieldEditingController.value.text},
        RequestTable.offset: {
          UserTable.tableName: {UserTable.id: (latest) ? latestContentId : bottomContentId},
        },
      },
    );
  }

  handleResponse({
    bool latest = false,
    String? token,
    required ResponseModel responseModel,
  }) {
    activeContent.handleResponse(responseModel);

    setState(() {
      activeContent.pagedModels<UserModel>().forEach((userId, userModel) {
        if (!_userIds.contains(userId)) {
          _userIds.add(userId);
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _userIds.isEmpty ? 0 : _userIds.reduce(max),
        setBottomContentId: _userIds.isEmpty ? 0 : _userIds.reduce(min),
      );

      _isSearchingFromStart = false;
    });
  }

  void _saveChanges() {
    Navigator.of(context).pop(_image);
  }
}
