import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photogram/core/bloc/theme/theme_bloc.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';

class PgPostContentImagesView extends StatefulWidget {
  final int postId;
  final int initialIndex;

  const PgPostContentImagesView({
    Key? key,
    required this.postId,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _PgPostContentImagesViewState createState() => _PgPostContentImagesViewState();
}

class _PgPostContentImagesViewState extends State<PgPostContentImagesView>
    with AppActiveContentInfiniteMixin, AppUtilsMixin {
  late PostModel _postModel;

  @override
  void initState() {
    super.initState();

    _postModel = activeContent.watch<PostModel>(widget.postId) ?? PostModel.none();
  }

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider:
              CachedNetworkImageProvider(_postModel.displayContent.items[index].displayItemDTO.urlOriginal),
        );
      },
      itemCount: _postModel.displayContent.items.length,
      pageController: PageController(initialPage: widget.initialIndex),
      loadingBuilder: (context, event) {
        return Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: PgUtils.darkCupertinoActivityIndicator(),
          ),
        );
      },
      backgroundDecoration: BoxDecoration(color: ThemeBloc.colorScheme.background),
    );
  }
}
