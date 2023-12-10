import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/collection/pg_collection_widget.dart';

class PgCollectionsPage extends CollectionsPage {
  const PgCollectionsPage({
    Key? key,
  }) : super(key: key);

  @override
  _PgCollectionsPageState createState() => _PgCollectionsPageState();
}

class _PgCollectionsPageState extends State<PgCollectionsPage> with AppActiveContentInfiniteMixin, AppUtilsMixin {
  final _collectionIds = <int>[];
  final _postIdsFetchedForAllPostsCollection = <int>[];

  @override
  void onLoadEvent() {
    _loadCollections(latest: true);
    _loadPostsForAllPostsCollection();
  }

  @override
  onReloadBeforeEvent() {
    _collectionIds.clear();
    _postIdsFetchedForAllPostsCollection.clear();
    return true;
  }

  @override
  onReloadAfterEvent() {
    _loadCollections(latest: true);
    _loadPostsForAllPostsCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.savedPosts),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
              onTap: () {
                AppNavigation.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ThemeBloc.pageInterface.createCollectionPage(),
                  ),
                  contentMixinReloadPage,
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: contentMixinReloadPage,
        child: Stack(
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: isLoadingBottom ? _collectionIds.length + 12 + 1 : _collectionIds.length + 1,
                itemBuilder: (context, index) => _buildCollection(context, index - 1),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollection(BuildContext context, int index) {
    if (-1 == index) {
      return _buildAllPostsWidget();
    }

    // agressive prefetching posts
    if (_collectionIds.length - 3 < index) {
      _loadCollections(waitForFrame: true);
    }

    if (_collectionIds.length > index) {
      return PgCollectionWidget(collectionId: _collectionIds[index]);
    }

    // add prelaoder
    return PgUtils.darkCupertinoActivityIndicator();
  }

  Widget _buildAllPostsWidget() {
    return GestureDetector(
      onTap: () {
        AppNavigation.push(
          context,
          MaterialPageRoute(
            builder: (_) => ThemeBloc.pageInterface.collectionPostsPage(
              collectionId: 0,
              defaultAppBarTitle: AppLocalizations.of(context)!.allPosts,
            ),
          ),
          utilMixinSetState,
        );
      },
      child: GridTile(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(4, (index) {
                      if (_postIdsFetchedForAllPostsCollection.length > index) {
                        var postModel = activeContent.watch<PostModel>(_postIdsFetchedForAllPostsCollection[index]);

                        if (null == postModel) {
                          return Opacity(
                            opacity: 0.1,
                            child: Container(
                              color: ThemeBloc.colorScheme.onBackground,
                            ),
                          );
                        }

                        return CachedNetworkImage(
                          placeholder: (_, __) => Container(color: Colors.grey[400]),
                          imageUrl: postModel.getFirstImageUrlFromPostContent,
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return Opacity(
                        opacity: 0.1,
                        child: Container(
                          color: ThemeBloc.colorScheme.onBackground,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  AppLocalizations.of(context)!.allPosts,
                  style: ThemeBloc.textInterface.boldBlackH5TextStyle().copyWith(overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
    utilMixinSetState(() {
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

  Future<void> _loadPostsForAllPostsCollection() async {
    ResponseModel responseModel = await activeContent.apiRepository.preparedRequest(
      requestType: REQ_TYPE_POST_SAVE_LOAD_LATEST,
      requestData: {
        RequestTable.offset: {
          PostSaveTable.tableName: {
            PostSaveTable.id: 0,
          },
        }
      },
    );

    if (responseModel.isNotResponse) return;

    setState(() {
      // send to standard response handler that'll do all the parsing stuff for us
      activeContent.handleResponse(responseModel);

      activeContent.pagedModels<PostSaveModel>().forEach((postSaveId, postSaveModel) {
        var postId = AppUtils.intVal(postSaveModel.savedPostId);

        if (!_postIdsFetchedForAllPostsCollection.contains(postId)) {
          _postIdsFetchedForAllPostsCollection.add(postId);
        }
      });
    });
  }
}
