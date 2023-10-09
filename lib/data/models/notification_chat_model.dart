import 'package:json_annotation/json_annotation.dart';
part 'notification_chat_model.g.dart';

@JsonSerializable()
class NotificationChatModel {
  String? gameId;
  String? createdAt;
  String? lastMessage;
  String? title;
  String? image;

  NotificationChatModel();


  factory NotificationChatModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationChatModelFromJson(json);
}