import 'package:json_annotation/json_annotation.dart';
part 'game_invitation_model.g.dart';

@JsonSerializable()
class GameInvitationModel {
  @JsonKey(includeIfNull: false)
  String? id;
  String? gameId;
  String? gameTitle;
  String? gameImage;
  String? gameStartTime;
  String? senderId;
  String? receiverId;
  String? createdAt;
  String? status;
  String? content;
  GameInvitationModel(this.id, this.gameId, this.gameTitle, this.gameImage, this.gameStartTime,
      this.senderId, this.receiverId, this.createdAt, this.status, this.content);

  factory GameInvitationModel.fromJson(Map<String, dynamic> json) => _$GameInvitationModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameInvitationModelToJson(this);
}