import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/data.dart';

// ignore: must_be_immutable
class PgProfileAvatarBig extends StatelessWidget {
  UserModel userModel;

  PgProfileAvatarBig({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: CircleAvatar(
        backgroundColor: Colors.grey[300],
        backgroundImage: CachedNetworkImageProvider(userModel.image),
      ),
    );
  }
}
