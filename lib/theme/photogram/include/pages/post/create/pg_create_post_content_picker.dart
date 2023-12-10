import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/bloc.dart';
import 'package:photogram/theme/photogram/include/pages/post/create/pg_create_post_image_editor.dart';
import 'package:photogram/theme/photogram/include/pages/post/create/pg_create_post_tag_people.dart.dart';
import 'package:photogram/theme/photogram/include/widgets/bottomsheet/pg_bottom_sheet_action.dart';

import 'package:photogram/theme/photogram/include/pages/pg_context.dart';

class PgCreatePostContentPicker extends StatefulWidget {
  final List<PostContentImage> images;
  final sliderIndicatorMaxItems = 5;

  const PgCreatePostContentPicker({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  _PgCreatePostContentPickerState createState() => _PgCreatePostContentPickerState();
}

class _PgCreatePostContentPickerState extends State<PgCreatePostContentPicker> with AppUtilsMixin {
  final _images = <PostContentImage>[];

  // indicator related
  final _visibleItemsInIndicator = <int>[];
  final _smallItemsInIndicator = <int>[];
  var _isIndicatorMovingForward = false;
  var _currentContentIndex = 0;
  var _previousContentIndex = 0;
  var _contentSlideForwardCount = 0;

  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _images.addAll(widget.images);
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
      title: Text(AppLocalizations.of(context)!.content),
      actions: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(_images),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            child: Icon(Icons.check, color: ThemeBloc.colorScheme.primary),
          ),
        )
      ],
    );
  }

  Widget _buildBody() {
    if (_images.isEmpty) {
      return Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: _openBottomMenu,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: ThemeBloc.colorScheme.primary, size: 25),
                  ThemeBloc.textInterface.normalThemeH5Text(text: AppLocalizations.of(context)!.addPhotos),
                  _buildBottomBar(),
                ],
              ),
            ),
          )
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCarousel(),
        _buildCarouselIndicator(),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        initialPage: 0,
        aspectRatio: 1,
        viewportFraction: 1,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          utilMixinSetState(() {
            // get the difference first
            var offsetDifference = index - _currentContentIndex;

            // update the state
            _previousContentIndex = _currentContentIndex;
            _currentContentIndex = index;

            // if we're moving forward but user moved to back
            if (_isIndicatorMovingForward && offsetDifference <= 0) {
              _contentSlideForwardCount--;
            }
            // if we're moving backward but user moved to forward
            else if (!_isIndicatorMovingForward && offsetDifference > 0) {
              _contentSlideForwardCount++;
            }

            // if can be set to moving forward
            if (_contentSlideForwardCount == widget.sliderIndicatorMaxItems - 1) {
              _isIndicatorMovingForward = true;

              // if can be set to moving backward
            } else if (_contentSlideForwardCount == 0) {
              _isIndicatorMovingForward = false;
            }
          });
        },
      ),
      items: _images.map((image) {
        return AspectRatio(
          aspectRatio: 1,
          child: SizedBox(
            width: double.infinity,
            child: Image.memory(
              image.getImageBytes,
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar() {
    if (_images.isEmpty) {
      return AppUtils.nothing();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: _openBottomMenu,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                const Icon(Icons.add, size: 20),
                ThemeBloc.textInterface.normalBlackH6Text(text: AppLocalizations.of(context)!.addMore),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: _editImage,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                const Icon(Icons.edit, size: 20),
                ThemeBloc.textInterface.normalBlackH6Text(text: AppLocalizations.of(context)!.edit),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: _tagPeople,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const Icon(Icons.person_add_alt, size: 20),
                      ThemeBloc.textInterface.normalBlackH6Text(text: AppLocalizations.of(context)!.tagPeople),
                    ],
                  ),
                  if (_images.length > _currentContentIndex && _images[_currentContentIndex].usersTagged.isNotEmpty)
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ThemeBloc.colorScheme.primary,
                          ),
                          child: Text(
                            _images[_currentContentIndex].usersTagged.length.toString(),
                            style: ThemeBloc.textInterface.boldBlackH6TextStyle().copyWith(
                                  color: ThemeBloc.colorScheme.onPrimary,
                                ),
                          ),
                        ),
                      ),
                    ),
                ],
              )),
        ),
        GestureDetector(
          onTap: _removeImage,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                const Icon(Icons.delete_outline_outlined, size: 20),
                ThemeBloc.textInterface.normalBlackH6Text(text: AppLocalizations.of(context)!.remove),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselIndicator() {
    var totalItems = _images.length;

    var dots = <Widget>[];
    var needsIntialization = _visibleItemsInIndicator.isEmpty;
    var isMovedForward = _currentContentIndex - _previousContentIndex > 0;

    if (_isIndicatorMovingForward && isMovedForward && _smallItemsInIndicator.contains(_currentContentIndex)) {
      _visibleItemsInIndicator.add(_currentContentIndex + 1);
      _visibleItemsInIndicator.remove(_currentContentIndex - widget.sliderIndicatorMaxItems - 1);

      _smallItemsInIndicator.remove(_currentContentIndex - widget.sliderIndicatorMaxItems - 1);

      _smallItemsInIndicator.add(_currentContentIndex - widget.sliderIndicatorMaxItems);
      _smallItemsInIndicator.add(_currentContentIndex + 1);
      _smallItemsInIndicator.remove(_currentContentIndex);
    } else if (!_isIndicatorMovingForward && !isMovedForward && _smallItemsInIndicator.contains(_currentContentIndex)) {
      _visibleItemsInIndicator.add(_currentContentIndex - 1);
      _visibleItemsInIndicator.remove(_currentContentIndex + widget.sliderIndicatorMaxItems + 1);

      _smallItemsInIndicator.remove(_currentContentIndex + widget.sliderIndicatorMaxItems + 1);

      _smallItemsInIndicator.add(_currentContentIndex + widget.sliderIndicatorMaxItems);
      _smallItemsInIndicator.add(_currentContentIndex - 1);
      _smallItemsInIndicator.remove(_currentContentIndex);
    }

    for (var index = 0; index < totalItems; index++) {
      var offsetFromActiveItem = index - _currentContentIndex;

      // initalization
      if (needsIntialization) {
        if (offsetFromActiveItem >= 0 && offsetFromActiveItem <= widget.sliderIndicatorMaxItems) {
          if (index == widget.sliderIndicatorMaxItems) {
            _smallItemsInIndicator.add(index);
          }
          _visibleItemsInIndicator.add(index);
        }
      }

      if (_visibleItemsInIndicator.contains(index)) {
        dots.add(
          Container(
            width: (_smallItemsInIndicator.contains(index)) ? 4.0 : (offsetFromActiveItem == 0 ? 9.0 : 7.0),
            height: (_smallItemsInIndicator.contains(index)) ? 4.0 : (offsetFromActiveItem == 0 ? 9.0 : 7.0),
            margin: const EdgeInsets.fromLTRB(2, 0, 2, 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: offsetFromActiveItem == 0
                  ? ThemeBloc.colorScheme.primary
                  : ThemeBloc.colorScheme.onBackground.withOpacity(0.2),
            ),
          ),
        );
      }
    }

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: dots);
  }

  void _openBottomMenu() {
    context.showBottomSheet(
      [
        PgBottomSheetAction(
          onTap: () {},
          title: AppLocalizations.of(context)!.addPhotos,
          isHeader: true,
        ),
        PgBottomSheetAction(
          onTap: () {},
          isDivider: true,
        ),
        PgBottomSheetAction(
          onTap: () async {
            var pickedImages = await _imagePicker.pickMultiImage();

            if (null != pickedImages) {
              // pop bottom nav
              if (AppNavigation.pop()) {
                _processImage(pickedImages);
              }
            }
          },
          iconData: Icons.upload_outlined,
          title: AppLocalizations.of(context)!.uploadPhotos,
        ),
        PgBottomSheetAction(
          onTap: () async {
            XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.camera);

            if (pickedImage != null) {
              if (AppNavigation.pop()) {
                _processImage([pickedImage]);
              }
            }
          },
          iconData: Icons.camera_alt_outlined,
          title: AppLocalizations.of(context)!.takeAPhoto,
        ),
      ],
    );
  }

  void _processImage(List<XFile> pickedImages) async {
    for (var pickedImage in pickedImages) {
      var file = File(pickedImage.path);
      var bytes = await file.readAsBytes();

      _images.add(
        PostContentImage(
          file: file,
          xFile: pickedImage,
          imageBytes: bytes,
        ),
      );
    }

    utilMixinSetState(() {
      _forceInitIndicator();
    });
  }

  void _editImage() async {
    var imageToEdit = _images[_currentContentIndex];

    var editedImage = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PgCreatePostImageEditor(image: imageToEdit),
      ),
    );

    if (editedImage is PostContentImage) {
      utilMixinSetState(() {
        _images[_images.indexOf(imageToEdit)] = editedImage;
      });
    }
  }

  void _removeImage() async {
    utilMixinSetState(() {
      _images.removeAt(_currentContentIndex);

      if (_currentContentIndex > 0) {
        _currentContentIndex = _currentContentIndex - 1;
      }
    });
  }

  void _tagPeople() async {
    var imageToTagPeopleOn = _images[_currentContentIndex];

    var imageWithPeopleTagged = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PgCreatePostTagPeople(image: imageToTagPeopleOn),
      ),
    );
    utilMixinSetState(() {
      if (imageWithPeopleTagged is PostContentImage) {
        _images[_images.indexOf(imageToTagPeopleOn)] = imageWithPeopleTagged;
      }
    });
  }

  void _forceInitIndicator() {
    _visibleItemsInIndicator.clear();
    _smallItemsInIndicator.clear();

    _isIndicatorMovingForward = false;

    _currentContentIndex = 0;
    _previousContentIndex = 0;
    _contentSlideForwardCount = 0;
  }
}
