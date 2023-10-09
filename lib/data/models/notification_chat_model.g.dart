// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationChatModel _$NotificationChatModelFromJson(
    Map<String, dynamic> json) {
  return NotificationChatModel()
    ..gameId = json['gameId'] as String?
    ..createdAt = json['createdAt'] as String?
    ..lastMessage = json['lastMessage'] as String?
    ..title = json['title'] as String?
    ..image = json['image'] as String?;
}

Map<String, dynamic> _$NotificationChatModelToJson(
        NotificationChatModel instance) =>
    <String, dynamic>{
      'gameId': instance.gameId,
      'createdAt': instance.createdAt,
      'lastMessage': instance.lastMessage,
      'title': instance.title,
      'image': instance.image,
    };
