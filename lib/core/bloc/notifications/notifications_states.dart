import 'package:photogram/import/data.dart';

class NotificationsState {
  final NotificationsCountDTO notificationsCountDTO;
  var hasCounts = false;

  NotificationsState(this.notificationsCountDTO) {
    hasCounts = notificationsCountDTO.isDTO &&
        ("0" != notificationsCountDTO.likeCount ||
            "0" != notificationsCountDTO.commentCount ||
            "0" != notificationsCountDTO.followCount ||
            "0" != notificationsCountDTO.otherCount);
  }
}
