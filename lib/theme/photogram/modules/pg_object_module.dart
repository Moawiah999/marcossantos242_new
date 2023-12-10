import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/theme/photogram/photogram_theme.dart';

class PgObjectModule {
  PhotogramTheme photogramTheme;
  PgObjectModule(this.photogramTheme);

  AppTile userAppTile({Key? key, required UserModel userModel}) {
    AppTile appTile = AppTile(key: key);

    appTile.leading = SizedBox(
      width: 50,
      height: 50,
      child: CircleAvatar(
        backgroundColor: Colors.grey[300],
        backgroundImage: CachedNetworkImageProvider(userModel.image),
      ),
    );

    appTile.title = Text(
      userModel.username,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: photogramTheme.modeImplementation.normalBlackH4,
    );

    if (userModel.displayName.isNotEmpty) {
      appTile.subtitle = Text(
        userModel.displayName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: photogramTheme.modeImplementation.normalGreyH4,
      );
    }

    return appTile;
  }
}
