// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationGameModel _$NotificationGameModelFromJson(
    Map<String, dynamic> json) {
  return NotificationGameModel(
    json['createdAt'] as String?,
    json['gameId'] as String?,
    json['image'] as String?,
    json['gameStartTime'] as String?,
    json['title'] as String?,
  );
}

Map<String, dynamic> _$NotificationGameModelToJson(
        NotificationGameModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'gameId': instance.gameId,
      'image': instance.image,
      'gameStartTime': instance.gameStartTime,
      'title': instance.title,
    };
