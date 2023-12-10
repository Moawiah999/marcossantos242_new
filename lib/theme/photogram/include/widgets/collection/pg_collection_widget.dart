import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photogram/core/bloc/theme/theme_bloc.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

class PgCollectionWidget extends StatefulWidget {
  final int collectionId;

  const PgCollectionWidget({
    Key? key,
    required this.collectionId,
  }) : super(key: key);

  @override
  State<PgCollectionWidget> createState() => _PgCollectionWidgetState();
}

class _PgCollectionWidgetState extends State<PgCollectionWidget> with AppActiveContentMixin, AppUtilsMixin {
  late CollectionModel _collectionModel;

  @override
  void onLoadEvent() {
    _collectionModel = activeContent.watch<CollectionModel>(widget.collectionId) ?? CollectionModel.none();
  }

  @override
  Widget build(BuildContext context) {
    if (_collectionModel.isNotModel) {
      return AppLogger.fail('${_collectionModel.runtimeType}(${widget.collectionId})');
    }

    return GestureDetector(
      onTap: () {
        AppNavigation.push(
          context,
          MaterialPageRoute(
            builder: (_) => ThemeBloc.pageInterface.collectionPostsPage(
              collectionId: _collectionModel.intId,
              defaultAppBarTitle: '',
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
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      placeholder: (_, __) => Container(color: Colors.grey[400]),
                      imageUrl: _collectionModel.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _collectionModel.displayTitle,
                  style: ThemeBloc.textInterface.boldBlackH5TextStyle().copyWith(overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
