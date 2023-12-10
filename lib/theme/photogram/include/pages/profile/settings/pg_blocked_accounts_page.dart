import 'dart:math';

import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';
import 'package:photogram/theme/photogram/include/pages/profile/settings/pg_block_user_page.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgBlockedAccountsPage extends BlockedAccountsPage {
  const PgBlockedAccountsPage({Key? key}) : super(key: key);

  @override
  _PgBlockedAccountsPageState createState() => _PgBlockedAccountsPageState();
}

class _PgBlockedAccountsPageState extends State<PgBlockedAccountsPage>
    with AppActiveContentInfiniteMixin, AppUserMixin, AppUtilsMixin {
  /// list of block ids
  final _userBlockIds = <int>[];

  @override
  void onLoadEvent() {
    _loadUserBlocks(latest: true);
  }

  @override
  onReloadBeforeEvent() {
    _userBlockIds.clear();
    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadUserBlocks(latest: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.blockedAccounts),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: _goToBlockUserPage,
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: contentMixinReloadPage,
        child: Stack(
          children: [
            if (_userBlockIds.isEmpty && !isLoadingCallInStack) _buildNoResults(),
            if (isLoadingLatest)
              Positioned(
                top: 0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(5),
                  color: ThemeBloc.colorScheme.background,
                  child: PgUtils.darkCupertinoActivityIndicator(),
                ),
              ),
            ListView.builder(
              itemCount: isLoadingBottom ? _userBlockIds.length + 1 : _userBlockIds.length,
              itemBuilder: (context, index) => _buildUserBlock(index),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserBlock(int index) {
    /*
    |--------------------------------------------------------------------------
    | aggressive prefetching
    |--------------------------------------------------------------------------
    */

    if (_userBlockIds.length - 3 < index) {
      _loadUserBlocks(waitForFrame: true);
    }

    /*
    |--------------------------------------------------------------------------
    | check if there are widgets to build:
    |--------------------------------------------------------------------------
    */

    if (_userBlockIds.length > index) {
      /*
      |--------------------------------------------------------------------------
      | get user block model:
      |--------------------------------------------------------------------------
      */

      var userBlockId = _userBlockIds[index];

      var userBlockModel = activeContent.read<UserBlockModel>(userBlockId) ?? UserBlockModel.none();
      if (userBlockModel.isNotModel) {
        return AppLogger.fail('${userBlockModel.runtimeType}($userBlockId)');
      }

      /*
      |--------------------------------------------------------------------------
      | get user model:
      |--------------------------------------------------------------------------
      */

      var userIdToBuild = AppUtils.intVal(userBlockModel.blockedUserId);

      var userModel = activeContent.read<UserModel>(userIdToBuild) ?? UserModel.none();
      if (userModel.isNotModel) {
        return AppLogger.fail('${userModel.runtimeType}($userIdToBuild)');
      }

      if (!userModel.isBlockedByCurrentUser) {
        _userBlockIds.remove(userBlockId);
        return AppUtils.nothing();
      }

      /*
      |--------------------------------------------------------------------------
      | build user tile:
      |--------------------------------------------------------------------------
      */

      return userMixinBuildUserTile(userModel);
    }

    return PgUtils.darkCupertinoActivityIndicator();
  }

  Future<void> _loadUserBlocks({bool latest = false, bool waitForFrame = false}) async {
    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_USER_BLOCK_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_USER_BLOCK_LOAD_BOTTOM,
      requestDataGenerator: () => {
        RequestTable.offset: {
          UserBlockTable.tableName: {UserBlockTable.id: latest ? latestContentId : bottomContentId},
        },
      },
    );
  }

  handleResponse({
    bool latest = false,
    required ResponseModel responseModel,
  }) {
    // push to active content first
    activeContent.handleResponse(responseModel);

    utilMixinSetState(() {
      activeContent.pagedModels<UserBlockModel>().forEach((userBlockId, userBlockModel) {
        if (!_userBlockIds.contains(userBlockId)) {
          _userBlockIds.add(userBlockId);
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _userBlockIds.isEmpty ? 0 : _userBlockIds.reduce(max),
        setBottomContentId: _userBlockIds.isEmpty ? 0 : _userBlockIds.reduce(min),
      );
    });
  }

  void _goToBlockUserPage() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PgBlockUserPage(),
      ),
    );

    // reload current page to show updated list of blocked accounts
    contentMixinReloadPage();
  }

  Widget _buildNoResults() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Center(
          child: ThemeBloc.textInterface.normalGreyH6Text(
            text: AppLocalizations.of(context)!.youHavntBlockedAnyone,
          ),
        ),
      ),
    );
  }
}
