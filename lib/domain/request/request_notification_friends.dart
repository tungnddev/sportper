import 'package:sportper/utils/definded/const.dart';
import 'package:json_annotation/json_annotation.dart';

class RequestNotificationFriendsModel {
  DateTime createdAt;
  String status;

  RequestNotificationFriendsModel(
      this.createdAt, this.status);

  factory RequestNotificationFriendsModel.fromFriendId() {
    return RequestNotificationFriendsModel(DateTime.now(), NotificationFriendStatusConst.PENDING);
  }

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt.toUtc().toIso8601String(),
        'status': status
      };
}
