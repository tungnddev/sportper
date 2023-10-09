import 'package:json_annotation/json_annotation.dart';
part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel {
  @JsonKey(includeIfNull: false)
  String? id;
  String? content;
  String? senderId;
  String? createdAt;
  String? type;

  ChatMessageModel(this.id, this.content, this.createdAt, this.senderId, this.type);

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}