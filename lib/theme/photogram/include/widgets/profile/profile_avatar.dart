import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

// ignore: must_be_immutable
class ProfileAvatar extends StatelessWidget {
  UserModel userModel;

  ProfileAvatar({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: InkResponse(
        child: Stack(
          children: [
            Positioned.fill(
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: CachedNetworkImageProvider(
                  userModel.image,
                ),
              ),
            ),
            Positioned(
              child: ClipOval(
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.blueAccent,
                    shape: CircleBorder(
                      side: Divider.createBorderSide(context, width: 2, color: Theme.of(context).cardColor),
                    ),
                  ),
                  padding: const EdgeInsets.all(2),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.add,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              right: 0,
              bottom: 0,
            )
          ],
        ),
        onTap: () {
          AppLogger.info("tap");
        },
      ),
    );
  }
}
