import 'package:json_annotation/json_annotation.dart';
part 'notification_friends_model.g.dart';

@JsonSerializable()
class NotificationFriendsModel {
  String? id;
  String? createdAt;
  String? status;

  NotificationFriendsModel(
      this.id, this.createdAt, this.status);

  factory NotificationFriendsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationFriendsModelFromJson(json);
}