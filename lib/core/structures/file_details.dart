import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';

class FileDetails {
  final Uint8List bytes;
  final String fieldName;
  final String namespace;
  final bool addIsCollection;
  final MediaType mediaType;

  FileDetails({
    required this.bytes,
    required this.fieldName,
    required this.namespace,
    required this.mediaType,
    this.addIsCollection = false,
  });
}
