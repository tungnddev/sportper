import 'package:sportper/domain/entities/buddies.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:json_annotation/json_annotation.dart';

class NotificationFriend {
  DateTime createdAt;
  SportperUser friend;
  StatusNotificationFriend status;

  NotificationFriend(this.createdAt, this.friend, this.status);
}

enum StatusNotificationFriend {
  pending, accepted, decline
}