// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(Map<String, dynamic> json) {
  return ChatMessageModel(
    json['id'] as String?,
    json['content'] as String?,
    json['createdAt'] as String?,
    json['senderId'] as String?,
    json['type'] as String?,
  );
}

Map<String, dynamic> _$ChatMessageModelToJson(ChatMessageModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['content'] = instance.content;
  val['senderId'] = instance.senderId;
  val['createdAt'] = instance.createdAt;
  val['type'] = instance.type;
  return val;
}
