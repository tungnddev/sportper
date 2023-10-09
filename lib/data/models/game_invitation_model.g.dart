// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_invitation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameInvitationModel _$GameInvitationModelFromJson(Map<String, dynamic> json) {
  return GameInvitationModel(
    json['id'] as String?,
    json['gameId'] as String?,
    json['gameTitle'] as String?,
    json['gameImage'] as String?,
    json['gameStartTime'] as String?,
    json['senderId'] as String?,
    json['receiverId'] as String?,
    json['createdAt'] as String?,
    json['status'] as String?,
    json['content'] as String?,
  );
}

Map<String, dynamic> _$GameInvitationModelToJson(GameInvitationModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['gameId'] = instance.gameId;
  val['gameTitle'] = instance.gameTitle;
  val['gameImage'] = instance.gameImage;
  val['gameStartTime'] = instance.gameStartTime;
  val['senderId'] = instance.senderId;
  val['receiverId'] = instance.receiverId;
  val['createdAt'] = instance.createdAt;
  val['status'] = instance.status;
  val['content'] = instance.content;
  return val;
}
