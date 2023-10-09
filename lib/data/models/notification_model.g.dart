// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return NotificationModel(
    json['id'] as String?,
    json['title'] as String?,
    json['subTitle'] as String?,
    json['image'] as String?,
    json['type'] as String?,
    json['createdAt'] as String?,
    json['titleNotification'] as String?,
    json['bodyNotification'] as String?,
    json['gameStartTime'] as String?,
    json['gameId'] as String?,
    json['gameInvitationId'] as String?,
    json['invitationStatus'] as String?,
    json['friendId'] as String?,
    json['friendStatus'] as String?,
  );
}

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['title'] = instance.title;
  val['subTitle'] = instance.subTitle;
  val['image'] = instance.image;
  val['type'] = instance.type;
  val['createdAt'] = instance.createdAt;
  val['titleNotification'] = instance.titleNotification;
  val['bodyNotification'] = instance.bodyNotification;
  writeNotNull('gameStartTime', instance.gameStartTime);
  writeNotNull('gameId', instance.gameId);
  writeNotNull('gameInvitationId', instance.gameInvitationId);
  writeNotNull('invitationStatus', instance.invitationStatus);
  writeNotNull('friendId', instance.friendId);
  writeNotNull('friendStatus', instance.friendStatus);
  return val;
}
