// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_friends_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationFriendsModel _$NotificationFriendsModelFromJson(
    Map<String, dynamic> json) {
  return NotificationFriendsModel(
    json['id'] as String?,
    json['createdAt'] as String?,
    json['status'] as String?,
  );
}

Map<String, dynamic> _$NotificationFriendsModelToJson(
        NotificationFriendsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'status': instance.status,
    };
