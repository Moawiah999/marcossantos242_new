import 'package:flutter/material.dart';

import 'package:photogram/import/interface.dart';

import 'package:photogram/theme/photogram/include/pages/post/pg_post_comments_page.dart';
import 'package:photogram/theme/photogram/include/widgets/post/pg_post_comments_page_wrapper.dart';

class PgPostCommentsPageWrap extends PostcommentsPage {
  final int postId;
  final bool focus;

  const PgPostCommentsPageWrap({
    Key? key,
    required this.postId,
    required this.focus,
  }) : super(key: key);

  @override
  PgPostCommentsPageWrapState createState() => PgPostCommentsPageWrapState();
}

class PgPostCommentsPageWrapState extends State<PgPostCommentsPageWrap> {
  final ValueNotifier<PostcommentsPageState> notifier = ValueNotifier<PostcommentsPageState>(
    PostcommentsPageState(
      selectedPostcommentId: 0,
      replyingToPostcommentId: 0,
      replyingToActualPostcommentId: 0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return PgPostCommentsPageWrapper(
      key: widget.key,
      postId: widget.postId,
      notifier: notifier,
      child: PgPostCommentsPage(postId: widget.postId, focus: widget.focus),
    );
  }
}
