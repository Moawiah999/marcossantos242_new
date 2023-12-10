import 'package:photogram/import/data.dart';

class PostDisplayUserTagDTO extends AbstractDisplayUserTagDTO {
  PostDisplayUserTagDTO({
    required int userId,
    required String username,
    required int offsetTop,
    required int offsetLeft,
  }) : super(
          userId: userId,
          username: username,
          offsetTop: offsetTop,
          offsetLeft: offsetLeft,
        );

  PostDisplayUserTagDTO.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap);
}
