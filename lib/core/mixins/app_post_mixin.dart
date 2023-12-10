import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';

mixin AppPostMixin<T extends StatefulWidget> on State<T> {
  /*
  |--------------------------------------------------------------------------
  | common functions for post:
  |--------------------------------------------------------------------------
  */

  void postMixinLikePost(PostModel postModel, [bool doLike = true]) async {
    // update widget
    setState(() {
      postModel.setLiked(doLike);
    });

    // do request
    var responseResult = await AppProvider.of(context).apiRepo.postLikeActionAdd(doLike: doLike, postModel: postModel);

    if (!responseResult) {
      // something went wrong, revert changes
      setState(() {
        postModel.setLiked(!doLike);
      });
    }
  }

  void postMixinLikePostcomment(PostCommentModel postCommentModel, [bool doLike = true]) async {
    // update widget
    setState(() {
      postCommentModel.setLiked(doLike);
    });

    // do request
    var responseResult = await AppProvider.of(context).apiRepo.postCommentLikeActionAdd(
          doLike: doLike,
          postCommentModel: postCommentModel,
        );

    if (!responseResult) {
      // something went wrong, revert changes
      setState(() {
        postCommentModel.setLiked(!doLike);
      });
    }
  }

  void postMixinSavePost(PostModel postModel, [bool doSave = true]) async {
    var collectionIds = postModel.savedToCollectionIds;

    // save it to all posts collection
    setState(() {
      if (doSave) {
        postModel.saveToCollectionId(LITERAL_ALL_POSTS_COLLECTION_ID_STRING);
      } else {
        postModel.removeFromAllCollections();
      }
    });

    // do request
    var responseResult = await AppProvider.of(context).apiRepo.postSaveActionAdd(doSave: doSave, postModel: postModel);

    if (!responseResult) {
      // something went wrong, revert changes
      setState(() {
        if (doSave) {
          postModel.removeFromCollectionId(LITERAL_ALL_POSTS_COLLECTION_ID_STRING);
        } else {
          collectionIds.forEach(postModel.saveToCollectionId);
        }
      });
    }
  }

  void postMixinDeletePost(PostModel postModel) async {
    setState(() => postModel.setVisibility(false));

    var responseResult = await AppProvider.of(context).apiRepo.deletePost(postModel: postModel);

    if (!responseResult) {
      setState(postModel.setVisibility);
    }
  }
}
