import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/pg_enums.dart';

class PgCreateCollectionPage extends CreateCollectionPage {
  const PgCreateCollectionPage({
    Key? key,
  }) : super(key: key);

  @override
  PgCreateCollectionPageState createState() => PgCreateCollectionPageState();
}

class PgCreateCollectionPageState extends State<PgCreateCollectionPage>
    with AppActiveContentInfiniteMixin, AppUtilsMixin, AppUserMixin {
  // duplicate free
  final _postSaveIds = <int>[];

  // include duplicates (as we are fetching all posts and post can be in multiple collections)
  final _postSaveIdsReceived = <int>[];

  final _selectedPostSaveIds = <int>[];
  final _postSaveIdOnPostIdJoinMap = <int, int>{};

  // creation related
  var _collectionSubmitLastError = '';
  var _selectedCoverPostSaveId = LITERAL_ALL_POSTS_COLLECTION_ID;
  var _currentPage = PgCreateCollectionPageSection.postSelectionPage;

  var _isCollectionSaveInProgress = false;

  final _textEditingController = TextEditingController();

  bool get isOnCoverSelectionPage => PgCreateCollectionPageSection.coverSelectionPage == _currentPage;
  bool get isOnPostSelectionPage => PgCreateCollectionPageSection.postSelectionPage == _currentPage;

  @override
  void onLoadEvent() {
    _loadPostSaves(latest: true);
  }

  @override
  void onDisposeEvent() {
    _textEditingController.dispose();
  }

  @override
  onReloadBeforeEvent() {
    if (_isCollectionSaveInProgress) return false;

    _postSaveIds.clear();
    _postSaveIdsReceived.clear();
    _selectedPostSaveIds.clear();
    _postSaveIdOnPostIdJoinMap.clear();

    _collectionSubmitLastError = '';

    _isCollectionSaveInProgress = false;

    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadPostSaves(latest: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: contentMixinReloadPage,
        child: _buildPageBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    leadingGen({
      IconData icon = Icons.arrow_back,
      void Function() onTap = AppNavigation.pop,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Icon(icon),
      );
    }

    if (isOnCoverSelectionPage) {
      return AppBar(
        leading: leadingGen(onTap: _goToCollectionSavePage),
        title: Text(AppLocalizations.of(context)!.selectCover),
      );
    }

    if (isOnPostSelectionPage) {
      return AppBar(
        leading: _selectedPostSaveIds.isEmpty
            ? leadingGen()
            : leadingGen(icon: Icons.close, onTap: () => utilMixinSetState(_selectedPostSaveIds.clear)),
        title: Text(
          _selectedPostSaveIds.isEmpty
              ? (AppLocalizations.of(context)!.selectToAdd)
              : (sprintf(AppLocalizations.of(context)!.nSelected, [_selectedPostSaveIds.length])),
        ),
        actions: [
          GestureDetector(
            onTap: _goToCollectionSavePage,
            child: PgUtils.appBarTextAction(AppLocalizations.of(context)!.next),
          )
        ],
      );
    }

    return AppBar(
      leading: leadingGen(
        icon: _postSaveIds.isEmpty ? Icons.close : Icons.arrow_back,
        onTap:
            _isCollectionSaveInProgress ? () {} : (_postSaveIds.isEmpty ? AppNavigation.pop : _goToPostSelectionPage),
      ),
      title: Text(AppLocalizations.of(context)!.createCollection),
      actions: [
        GestureDetector(
          onTap: _isCollectionSaveInProgress ? () {} : _saveCollection,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: ThemeBloc.textInterface.normalThemeH3Text(
              text: _isCollectionSaveInProgress
                  ? AppLocalizations.of(context)!.saving
                  : AppLocalizations.of(context)!.save,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPageBody() {
    if (isOnCoverSelectionPage || isOnPostSelectionPage) {
      return GridView.builder(
        itemCount: isOnCoverSelectionPage
            ? _selectedPostSaveIds.length
            : (isLoadingBottom ? _postSaveIds.length + 12 : _postSaveIds.length),
        itemBuilder: (context, index) =>
            _buildCoverSelectablePost(isOnCoverSelectionPage ? _selectedPostSaveIds : _postSaveIds, index),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
      );
    }

    return _buildCollectionSavePage();
  }

  Widget _buildCollectionSavePage() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCollectionCoverSection(),
            _buildCollectionNameField(),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCoverSection() {
    var coverPostSaveId = _getCoverPostSaveId();

    if (null == coverPostSaveId) {
      return AppUtils.nothing();
    }

    var postModel = activeContent.watch<PostModel>(_postSaveIdOnPostIdJoinMap[coverPostSaveId]!)!;

    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(imageUrl: postModel.getFirstImageUrlFromPostContent),
          ),
        ),
        PgUtils.sizedBoxH(20),
        GestureDetector(
          onTap: _goToCoverSelectionPage,
          child: ThemeBloc.textInterface.normalThemeH3Text(text: AppLocalizations.of(context)!.changeCover),
        ),
      ],
    );
  }

  Widget _buildCollectionNameField() {
    return TextField(
      controller: _textEditingController,
      textAlign: TextAlign.center,
      autofocus: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: AppLocalizations.of(context)!.collectionName,
        errorText: _collectionSubmitLastError.isEmpty ? null : _collectionSubmitLastError,
        hintStyle: ThemeBloc.textInterface.normalGreyH3TextStyle(),
        errorStyle: ThemeBloc.textInterface.normalBlackH5TextStyle().copyWith(
              color: ThemeBloc.colorScheme.error,
            ),
      ),
    );
  }

  Widget _buildCoverSelectablePost(List<int> listToUse, int index) {
    // agressive prefetching posts
    if (isOnPostSelectionPage && listToUse.length - 3 < index) {
      _loadPostSaves(waitForFrame: true);
    }

    if (listToUse.length > index) {
      var postSaveId = listToUse[index];

      var postIdToBuild = _postSaveIdOnPostIdJoinMap[postSaveId]!;

      var isPostSaveSelected = _selectedPostSaveIds.contains(postSaveId);
      var isPostSaveSelectedAsCover = postSaveId == _selectedCoverPostSaveId;

      var isPostSelected = isOnCoverSelectionPage ? isPostSaveSelectedAsCover : isPostSaveSelected;

      var postModel = activeContent.watch<PostModel>(postIdToBuild) ?? PostModel.none();
      if (postModel.isNotModel) {
        return AppLogger.fail('${postModel.runtimeType}($postIdToBuild)');
      }
      if (!postModel.isVisible) {
        return PgUtils.gridImageStationary();
      }

      return GestureDetector(
        onTap: isOnCoverSelectionPage ? () => _setCoverPostSave(postSaveId) : () => _togglePostSaveItem(postSaveId),
        child: Stack(
          children: [
            Opacity(
              opacity: isPostSelected ? 0.3 : 1,
              child: AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: postModel.getFirstImageUrlFromPostContent,
                    fit: BoxFit.cover,
                  )),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Opacity(
                  opacity: 0.7,
                  child: isPostSelected
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: ThemeBloc.colorScheme.primary,
                        )
                      : const Icon(Icons.circle_outlined, color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (isOnCoverSelectionPage) {
      return AppUtils.nothing();
    }

    // add prelaoder
    return PgUtils.gridImagePreloader();
  }

  Future<void> _loadPostSaves({bool latest = false, bool waitForFrame = false}) async {
    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_POST_SAVE_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_POST_SAVE_LOAD_BOTTOM,
      requestDataGenerator: () => {
        RequestTable.offset: {
          PostSaveTable.tableName: {
            PostSaveTable.id: (latest) ? latestContentId : bottomContentId,
          },
        }
      },
    );
  }

  handleResponse({
    bool latest = false,
    required ResponseModel responseModel,
  }) {
    activeContent.handleResponse(responseModel);

    utilMixinSetState(() {
      activeContent.pagedModels<PostSaveModel>().forEach((postSaveId, postSaveModel) {
        if (!_postSaveIdsReceived.contains(postSaveId)) {
          _postSaveIdsReceived.add(postSaveId);
        }

        var postId = AppUtils.intVal(postSaveModel.savedPostId);

        // duplicate free
        if (!_postSaveIdOnPostIdJoinMap.containsValue(postId)) {
          if (!_postSaveIds.contains(postSaveId)) {
            _postSaveIds.add(postSaveId);
          }

          // join on post id
          if (!_postSaveIdOnPostIdJoinMap.containsKey(postSaveId)) {
            _postSaveIdOnPostIdJoinMap.addAll({postSaveId: AppUtils.intVal(postId)});
          }
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _postSaveIdsReceived.isEmpty ? 0 : _postSaveIdsReceived.reduce(max),
        setBottomContentId: _postSaveIdsReceived.isEmpty ? 0 : _postSaveIdsReceived.reduce(min),
      );

      if (_postSaveIds.isEmpty) {
        _currentPage = PgCreateCollectionPageSection.collectionSavePage;
      }
    });
  }

  Future<void> _saveCollection() async {
    if (_isCollectionSaveInProgress) return;

    var displayTitle = _textEditingController.text;

    utilMixinSetState(() {
      _isCollectionSaveInProgress = true;
    });

    var requestData = <String, Map<String, dynamic>>{
      PostSaveTable.tableName: {
        PostSaveTable.id: _selectedPostSaveIds,
      },
      CollectionTable.tableName: {
        CollectionTable.displayTitle: displayTitle,
      },
    };

    var coverPostSaveId = _getCoverPostSaveId();

    if (null != coverPostSaveId) {
      requestData[CollectionTable.tableName]!.addAll({CollectionTable.extraCoverPostSaveId: coverPostSaveId});
    }

    var responseModel = await AppProvider.of(context).apiRepo.preparedRequest(
          requestType: REQ_TYPE_COLLECTION_ADD,
          requestData: requestData,
        );

    if (responseModel.isResponse) {
      switch (responseModel.message) {
        case D_ERROR_COLLECTION_DISPLAY_TITLE_MAX_LEN_MSG:
          return utilMixinSetState(() {
            _isCollectionSaveInProgress = false;
            _collectionSubmitLastError =
                sprintf(AppLocalizations.of(context)!.fieldErrorCollectionDisplayTitleMaxLength, [
              AppSettings.getString(SETTING_MAX_LEN_COLLECTION_DISPLAY_TITLE),
            ]);
          });

        case D_ERROR_COLLECTION_DISPLAY_TITLE_MIN_LEN_MSG:
          return utilMixinSetState(() {
            _isCollectionSaveInProgress = false;
            _collectionSubmitLastError =
                sprintf(AppLocalizations.of(context)!.fieldErrorCollectionDisplayTitleMinLength, [
              AppSettings.getString(SETTING_MIN_LEN_COLLECTION_DISPLAY_TITLE),
            ]);
          });

        case SUCCESS_MSG:
          AppNavigation.pop();
          break;
      }

      return;
    }

    utilMixinSetState(() {
      _isCollectionSaveInProgress = false;
      _collectionSubmitLastError = AppLocalizations.of(context)!.somethingWentWrongMessage;
    });
  }

  int? _getCoverPostSaveId() {
    // if user has selected a different cover
    if (LITERAL_ALL_POSTS_COLLECTION_ID != _selectedCoverPostSaveId) {
      return _selectedCoverPostSaveId;
    }

    // else use first post if available
    else if (_selectedPostSaveIds.isNotEmpty) {
      return _selectedPostSaveIds.first;
    }

    return null;
  }

  void _togglePostSaveItem(int postSaveId) {
    utilMixinSetState(() {
      if (_selectedPostSaveIds.contains(postSaveId)) {
        _selectedPostSaveIds.remove(postSaveId);
      } else {
        _selectedPostSaveIds.add(postSaveId);
      }
    });
  }

  void _setCoverPostSave(int postSaveId) {
    utilMixinSetState(() {
      _selectedCoverPostSaveId = postSaveId;
      _currentPage = PgCreateCollectionPageSection.collectionSavePage;
    });
  }

  void _moveToPage(PgCreateCollectionPageSection page) {
    if (_isCollectionSaveInProgress) return;

    utilMixinSetState(() {
      _currentPage = page;
    });
  }

  void _goToCoverSelectionPage() => _moveToPage(PgCreateCollectionPageSection.coverSelectionPage);
  void _goToPostSelectionPage() => _moveToPage(PgCreateCollectionPageSection.postSelectionPage);
  void _goToCollectionSavePage() => _moveToPage(PgCreateCollectionPageSection.collectionSavePage);
}
