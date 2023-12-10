import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

mixin AppHashtagMixin<T extends StatefulWidget> on State<T> {
  void hashtagMixinFollowUser(HashtagModel hashtagModel, [bool doFollow = true]) async {
    setState(() {
      hashtagModel.setFollowing(doFollow);
    });

    var responseResult = await AppProvider.of(context).apiRepo.followHashtag(
          doFollow: doFollow,
          hashtagModel: hashtagModel,
        );

    if (!responseResult) {
      setState(() {
        hashtagModel.setFollowing(!doFollow);
      });
    }
  }
}
