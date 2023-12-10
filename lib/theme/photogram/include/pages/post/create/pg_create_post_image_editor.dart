import 'package:flutter/material.dart';
import 'package:cropperx/cropperx.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';

import 'package:photogram/theme/photogram/include/pg_enums.dart';
import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/pages/post/create/pg_image_filters.dart';

class PgCreatePostImageEditor extends StatefulWidget {
  final PostContentImage image;

  const PgCreatePostImageEditor({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  _PgCreatePostImageEditorState createState() => _PgCreatePostImageEditorState();
}

class _PgCreatePostImageEditorState extends State<PgCreatePostImageEditor> with AppUtilsMixin {
  late final PostContentImage _image;
  final _cropperKey = GlobalKey<State<StatefulWidget>>();
  final _availableFilters = <PgImageFilter, ImageFilter>{};
  late ImageFilter _imageFilter;

  var _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    if (_availableFilters.isEmpty) {
      _loadFilters();
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.edit),
      actions: [
        GestureDetector(
          onTap: _saveImage,
          child: _isProcessing
              ? PgUtils.appBarTextAction(AppLocalizations.of(context)!.processing)
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  child: Icon(Icons.check, color: ThemeBloc.colorScheme.primary),
                ),
        )
      ],
    );
  }

  Widget _buildBody() {
    return IgnorePointer(
      ignoring: _isProcessing,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildImageEditor(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildImageEditor() {
    return AspectRatio(
      aspectRatio: 1,
      child: SizedBox(
        width: double.infinity,
        child: Cropper(
          cropperKey: _cropperKey,
          overlayType: OverlayType.grid,
          image: Image.file(
            _image.file,
            color: _imageFilter.color,
            colorBlendMode: _imageFilter.colorBlendMode,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Expanded(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 120),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _availableFilters
                .map(
                  (key, filter) => MapEntry(
                    key,
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: GestureDetector(
                                onTap: () => _setFilter(filter),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: filter == _imageFilter
                                        ? ThemeBloc.colorScheme.primary.withOpacity(0.5)
                                        : ThemeBloc.colorScheme.onBackground.withOpacity(0.1),
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    border: Border.all(
                                      width: 6,
                                      color: filter == _imageFilter
                                          ? ThemeBloc.colorScheme.primary.withOpacity(0.5)
                                          : ThemeBloc.colorScheme.onBackground.withOpacity(0.1),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: Image.file(
                                      _image.file,
                                      fit: BoxFit.cover,
                                      color: filter.color,
                                      colorBlendMode: filter.colorBlendMode,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          PgUtils.sizedBoxH(6),
                          ThemeBloc.textInterface.normalBlackH6Text(text: filter.title)
                        ],
                      ),
                    ),
                  ),
                )
                .values
                .toList(),
          ),
        ),
      ),
    );
  }

  void _saveImage() async {
    if (_isProcessing) return;

    utilMixinSetState(() {
      _isProcessing = true;
    });

    var editedBytes = await Cropper.crop(cropperKey: _cropperKey);

    if (null == editedBytes) {
      utilMixinSomethingWentWrongMessage();

      return utilMixinSetState(() {
        _isProcessing = false;
      });
    }

    _image.setImageBytes = editedBytes;

    Navigator.of(context).pop(_image);
  }

  void _loadFilters() {
    _availableFilters.addAll({
      PgImageFilter.none: PgImageFilterNone(context),
      PgImageFilter.retro: PgImageFilterRetro(context),
      PgImageFilter.exclusion: PgImageFilterExclusion(context),
      PgImageFilter.grayScale: PgImageFilterGrayScale(context),
      PgImageFilter.brave: PgImageFilterBrave(context),
      PgImageFilter.sepiaScale: PgImageFilterSepiaScale(context),
      PgImageFilter.night: PgImageFilterNight(context),
      PgImageFilter.ratio: PgImageFilterRatio(context),
    });

    _imageFilter = _availableFilters[PgImageFilter.none]!;
  }

  void _setFilter(ImageFilter filter) {
    utilMixinSetState(() {
      _imageFilter = filter;
    });
  }
}
