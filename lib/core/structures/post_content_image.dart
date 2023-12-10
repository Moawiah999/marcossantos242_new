import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:photogram/import/data.dart';

class PostContentImage {
  final File file;
  final XFile xFile;

  late Uint8List _bytes;

  Uint8List get getImageBytes => _bytes;
  set setImageBytes(Uint8List bytes) => _bytes = bytes;

  final usersTagged = <int, UserModel>{};
  final displayUserTagsOnImage = <PostDisplayUserTagDTO>[];

  PostContentImage({required this.xFile, required this.file, required Uint8List imageBytes}) {
    _bytes = imageBytes;
  }
}
