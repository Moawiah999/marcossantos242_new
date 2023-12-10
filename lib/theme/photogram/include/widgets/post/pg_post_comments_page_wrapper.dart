import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class PgPostCommentsPageWrapper extends InheritedWidget {
  final int postId;
  final _postCommentIdsToIgnore = <int>[];

  final ValueNotifier<PostcommentsPageState> notifier;

  PgPostCommentsPageWrapper({
    Key? key,
    required this.postId,
    required this.notifier,
    required Widget child,
  }) : super(key: key, child: child);

  static PgPostCommentsPageWrapper? of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<PgPostCommentsPageWrapper>();
  }

  List<int> get getPostcommentIdsToIgnore => _postCommentIdsToIgnore;

  bool isReplyingToAPostcomment() => 0 != notifier.value.replyingToPostcommentId;
  bool isPostcommentSelected() => 0 != notifier.value.selectedPostcommentId;

  void clearPostcommentIdsToIgnore() => _postCommentIdsToIgnore.clear();
  void addPostcommentIdToIgnore(int postCommentId) => _postCommentIdsToIgnore.add(postCommentId);

  int get selectedPostcommentId => notifier.value.selectedPostcommentId;
  int get replyingToPostcommentId => notifier.value.replyingToPostcommentId;
  int get replyingToActualPostcommentId => notifier.value.replyingToActualPostcommentId;

  void updateNotifier({
    required int selectedPostcommentId,
    required int replyingToPostcommentId,
    required int replyingToActualPostcommentId,
  }) {
    notifier.value = PostcommentsPageState(
      selectedPostcommentId: selectedPostcommentId,
      replyingToPostcommentId: replyingToPostcommentId,
      replyingToActualPostcommentId: replyingToActualPostcommentId,
    );
  }

  void clearNotifier() => updateNotifier(
        selectedPostcommentId: 0,
        replyingToPostcommentId: 0,
        replyingToActualPostcommentId: 0,
      );

  @override
  bool updateShouldNotify(PgPostCommentsPageWrapper oldWidget) {
    if (oldWidget.selectedPostcommentId != notifier.value.selectedPostcommentId ||
        oldWidget.replyingToPostcommentId != notifier.value.replyingToPostcommentId) {
      return true;
    }

    return false;
  }
}

class PostcommentsPageState {
  final int selectedPostcommentId;
  final int replyingToPostcommentId;
  final int replyingToActualPostcommentId;

  PostcommentsPageState({
    Key? key,
    required this.selectedPostcommentId,
    required this.replyingToPostcommentId,
    required this.replyingToActualPostcommentId,
  });
}
