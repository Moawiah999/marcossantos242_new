import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:sprintf/sprintf.dart';

class PgAddToCollectionBottomSheet extends StatefulWidget {
  final int postId;

  const PgAddToCollectionBottomSheet({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  _PgAddToCollectionBottomSheetState createState() => _PgAddToCollectionBottomSheetState();
}

class _PgAddToCollectionBottomSheetState extends State<PgAddToCollectionBottomSheet>
    with AppActiveContentInfiniteMixin, AppUtilsMixin {
  late PostModel _postModel;

  final _collectionIds = <int>[];
  final _textEditingController = TextEditingController();

  var _collectionSubmitLastError = '';

  var _isOnCreateNewCollectionPage = false;
  var _isCollectionSaveInProgress = false;

  @override
  void onLoadEvent() {
    _postModel = activeContent.watch<PostModel>(widget.postId)!;

    _loadCollections(latest: true);
  }

  @override
  void onDisposeEvent() {
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ThemeBloc.textInterface.boldBlackH4Text(
            text: _isOnCreateNewCollectionPage
                ? AppLocalizations.of(context)!.newCollection
                : AppLocalizations.of(context)!.saveTo),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: _isOnCreateNewCollectionPage
            ? GestureDetector(
                onTap: () => setState(() => _isOnCreateNewCollectionPage = false),
                child: const Icon(Icons.arrow_back),
              )
            : null,
        actions: [
          if (!_isOnCreateNewCollectionPage)
            GestureDetector(
              onTap: () => setState(() => _isOnCreateNewCollectionPage = true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                child: const Icon(Icons.add),
              ),
            )
          else
            GestureDetector(
              onTap: _isCollectionSaveInProgress ? () {} : _createAndSaveToCollection,
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThemeBloc.widgetInterface.divider(),
          if (isLoadingLatest)
            Expanded(
              child: Center(
                child: PgUtils.darkCupertinoActivityIndicator(),
              ),
            ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (!_isOnCreateNewCollectionPage) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        itemCount: isLoadingBottom ? _collectionIds.length + 1 : _collectionIds.length,
        itemBuilder: _buildCollection,
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: _postModel.getFirstImageUrlFromPostContent,
                  fit: BoxFit.cover,
                  width: 80,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextField(
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
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCollection(BuildContext context, int index) {
    // agressive prefetching posts
    if (_collectionIds.length - 3 < index) {
      _loadCollections(waitForFrame: true);
    }

    if (_collectionIds.length > index) {
      var collectionModel = activeContent.watch<CollectionModel>(_collectionIds[index]) ?? CollectionModel.none();

      var isPostSaved = _postModel.isSavedInCollection(collectionModel.id);

      return GestureDetector(
        onTap: () {
          if (isPostSaved) {
            _removeFromCollectionRequest(collectionModel.intId);
          } else {
            _saveToCollection(collectionModel.intId);
          }
        },
        child: Container(
          height: 120,
          width: 120,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: isPostSaved ? 0.5 : 1,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              placeholder: (_, __) => Container(color: Colors.grey[400]),
                              imageUrl: collectionModel.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (isPostSaved)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(Icons.check, color: ThemeBloc.colorScheme.primary),
                            ),
                          ),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  collectionModel.displayTitle,
                  style: ThemeBloc.textInterface.boldBlackH5TextStyle().copyWith(overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        ),
      );
    }

    return SizedBox(height: 120, width: 120, child: PgUtils.darkCupertinoActivityIndicator());
  }

  Future<void> _loadCollections({bool latest = false, bool waitForFrame = false}) async {
    contentMixinLoadContent(
      latest: latest,
      waitForFrame: waitForFrame,
      responseHandler: handleResponse,
      latestEndpoint: REQ_TYPE_COLLECTION_LOAD_LATEST,
      bottomEndpoint: REQ_TYPE_COLLECTION_LOAD_BOTTOM,
      requestDataGenerator: () {
        if (latest) {
          return {
            RequestTable.offset: {
              CollectionTable.tableName: {CollectionTable.id: latestContentId},
            },
          };
        } else {
          return {
            RequestTable.offset: {
              CollectionTable.tableName: {CollectionTable.id: bottomContentId},
            },
          };
        }
      },
    );
  }

  handleResponse({
    bool latest = false,
    required ResponseModel responseModel,
  }) {
    setState(() {
      activeContent.handleResponse(responseModel);

      activeContent.pagedModels<CollectionModel>().forEach((collectionId, postModel) {
        if (!_collectionIds.contains(collectionId)) {
          _collectionIds.add(collectionId);
        }
      });

      contentMixinUpdateData(
        setLatestContentId: _collectionIds.isEmpty ? 0 : _collectionIds.reduce(max),
        setBottomContentId: _collectionIds.isEmpty ? 0 : _collectionIds.reduce(min),
      );
    });
  }

  Future<void> _saveToCollection(int collectionId) async {
    if (_isCollectionSaveInProgress) return;

    setState(() {
      _collectionSubmitLastError = '';
      _isCollectionSaveInProgress = true;
    });

    var requestData = <String, Map<String, dynamic>>{
      PostSaveTable.tableName: {
        PostSaveTable.savedPostId: _postModel.intId,
        PostSaveTable.savedToCollectionId: collectionId,
      }
    };

    _saveToCollectionRequest(requestData);
  }

  Future<void> _createAndSaveToCollection() async {
    if (_isCollectionSaveInProgress) return;

    var displayTitle = _textEditingController.text;

    utilMixinSetState(() {
      _collectionSubmitLastError = '';
      _isCollectionSaveInProgress = true;
    });

    var requestData = <String, Map<String, dynamic>>{
      PostSaveTable.tableName: {
        PostSaveTable.savedPostId: _postModel.intId,
      },
      CollectionTable.tableName: {
        CollectionTable.displayTitle: displayTitle,
      }
    };

    _saveToCollectionRequest(requestData);
  }

  Future<void> _saveToCollectionRequest(Map<String, Map<String, dynamic>> requestData) async {
    var responseModel = await AppProvider.of(context).apiRepo.preparedRequest(
          requestType: REQ_TYPE_POST_SAVE_ADD,
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
          if (responseModel.contains(PostSaveTable.tableName)) {
            var postSaveModel = PostSaveModel.fromJson(responseModel.first(PostSaveTable.tableName));

            _postModel.saveToCollectionId(postSaveModel.savedToCollectionId);
          }

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

  Future<void> _removeFromCollectionRequest(int collectionId) async {
    if (_isCollectionSaveInProgress) return;

    utilMixinSetState(() {
      _collectionSubmitLastError = '';
      _isCollectionSaveInProgress = true;
    });

    var requestData = <String, Map<String, dynamic>>{
      PostSaveTable.tableName: {
        PostSaveTable.savedPostId: _postModel.intId,
        PostSaveTable.savedToCollectionId: collectionId,
      }
    };

    var responseModel = await AppProvider.of(context).apiRepo.preparedRequest(
          requestType: REQ_TYPE_POST_SAVE_REMOVE,
          requestData: requestData,
        );

    if (responseModel.isResponse && SUCCESS_MSG == responseModel.message) {
      _postModel.removeFromCollectionId(collectionId.toString());

      AppNavigation.pop();

      return;
    }

    utilMixinSetState(() {
      _isCollectionSaveInProgress = false;
      _collectionSubmitLastError = AppLocalizations.of(context)!.somethingWentWrongMessage;
    });
  }
}
