import 'dart:async';

import 'package:flutter/material.dart';

import 'package:photogram/import/core.dart';
import 'package:photogram/import/data.dart';
import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pg_utils.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_feed_post_widget.dart';

class PgPostPage extends PostPage {
  final int postId;

  const PgPostPage({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  _PgPostPageState createState() => _PgPostPageState();
}

class _PgPostPageState extends State<PgPostPage> with AppActiveContentInfiniteMixin, AppUserMixin, AppUtilsMixin {
  late PostModel _postModel;
  var _postLoadingInProgress = false;

  @override
  void onLoadEvent() {
    _postModel = activeContent.watch<PostModel>(widget.postId) ?? PostModel.none();

    if (_postModel.isNotModel) {
      _loadPost(doSetState: true);
    }
  }

  @override
  onReloadAfterEvent() {
    _loadPost();
  }

  @override
  Widget build(BuildContext context) {
    if (_postModel.isNotModel) {
      return PgUtils.darkCupertinoActivityIndicator();
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.post)),
      body: RefreshIndicator(
        onRefresh: contentMixinReloadPage,
        child: SingleChildScrollView(
          child: PgFeedPostWidget(postId: _postModel.intId),
        ),
      ),
    );
  }

  Future<void> _loadPost({bool doSetState = false}) async {
    if (_postLoadingInProgress) return;
    _postLoadingInProgress = true;

    var responseModel = await AppProvider.of(context).apiRepo.postById(postId: widget.postId.toString());

    activeContent.handleResponse(responseModel);

    var postModel = activeContent.watch<PostModel>(widget.postId) ?? PostModel.none();
    if (postModel.isNotModel) {
      utilMixinSomethingWentWrongMessage();
      return;
    }

    if (doSetState) {
      utilMixinSetState(() {
        _postModel = postModel;
      });
    } else {
      _postModel = postModel;
    }

    _postLoadingInProgress = false;
  }
}
