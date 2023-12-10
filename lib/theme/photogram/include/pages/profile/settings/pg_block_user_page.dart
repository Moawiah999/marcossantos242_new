import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgBlockUserPage extends SearchPage {
  const PgBlockUserPage({
    Key? key,
  }) : super(key: key);

  @override
  _PgBlockUserPageState createState() => _PgBlockUserPageState();
}

class _PgBlockUserPageState extends State<PgBlockUserPage>
    with AppActiveContentInfiniteMixin, AppUserMixin, AppUtilsMixin {
  final _userIds = <int>[];

  final _searchTextFieldFocusNode = FocusNode();
  final _searchTextFieldEditingController = TextEditingController();

  // search related
  var _token = PgUtils.random();
  var _lastSearchedValue = '';
  var _isSearchingFromStart = false;
  late Timer _searchTriggerTimer;

  @override
  void onLoadEvent() {
    _searchTextFieldEditingController.addListener(_search);
    _searchTriggerTimer = Timer(const Duration(seconds: 1), _search);

    _searchTextFieldFocusNode.requestFocus();
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
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 25,
        title: ThemeBloc.widgetInterface.standardTextField(
          context: context,
          border: InputBorder.none,
          focusNode: _searchTextFieldFocusNode,
          controller: _searchTextFieldEditingController,
          hintText: AppLocalizations.of(context)!.search,
        ),
      ),
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    if (_isSearchingFromStart) {
      return Container(
        color: ThemeBloc.colorScheme.background,
        child: Align(
          alignment: Alignment.center,
          child: ThemeBloc.textInterface.normalThemeH5Text(text: AppLocalizations.of(context)!.searching),
        ),
      );
    }

    return ListView.builder(
      itemCount: isLoadingBottom ? _userIds.length + 1 : _userIds.length,
      itemBuilder: _buildUser,
    );
  }

  Widget _buildUser(BuildContext context, int index) {
    if (_userIds.length - 3 < index) {
      _loadUsers(waitForFrame: true);
    }

    if (_userIds.length > index) {
      var userId = _userIds[index];

      var userModel = activeContent.watch<UserModel>(userId) ?? UserModel.none();
      if (userModel.isNotModel) {
        return AppLogger.fail('${userModel.runtimeType}($userId)');
      }

      if (userModel.isBlockedByCurrentUser) {
        return userMixinBuildUserTile(userModel);
      }

      AppTile appTile = AppTile();

      appTile.leading = SizedBox(
        width: 50,
        height: 50,
        child: CachedNetworkImage(
          imageUrl: userModel.image,
          imageBuilder: (context, imageProvider) {
            return CircleAvatar(backgroundImage: imageProvider);
          },
        ),
      );

      appTile.title = Text(
        userModel.username,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: ThemeBloc.textInterface.normalBlackH4TextStyle(),
      );

      if (userModel.displayName.isNotEmpty) {
        appTile.subtitle = Text(
          userModel.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: ThemeBloc.textInterface.normalGreyH4TextStyle(),
        );
      }

      appTile.trailing = ThemeBloc.widgetInterface.hollowButton(
        text: AppLocalizations.of(context)!.block,
        onTapCallback: () => userMixinBlockUser(userModel),
      );

      return appTile.dispense();
    }

    return PgUtils.darkCupertinoActivityIndicator();
  }

  Future<void> _search() async {
    if (_searchTextFieldEditingController.value.text.isEmpty) {
      utilMixinSetState(() {
        _isSearchingFromStart = false;
      });

      return;
    }

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
}
