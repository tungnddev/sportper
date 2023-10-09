import 'package:json_annotation/json_annotation.dart';
part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  @JsonKey(includeIfNull: false)
  String? id;
  String? title;
  String? subTitle;
  String? image;
  String? type;
  String? createdAt;
  String? titleNotification;
  String? bodyNotification;
  @JsonKey(includeIfNull: false)
  String? gameStartTime;
  @JsonKey(includeIfNull: false)
  String? gameId;
  @JsonKey(includeIfNull: false)
  String? gameInvitationId;
  @JsonKey(includeIfNull: false)
  String? invitationStatus;
  @JsonKey(includeIfNull: false)
  String? friendId;
  @JsonKey(includeIfNull: false)
  String? friendStatus;


  NotificationModel(
      this.id,
      this.title,
      this.subTitle,
      this.image,
      this.type,
      this.createdAt,
      this.titleNotification,
      this.bodyNotification,
      this.gameStartTime,
      this.gameId,
      this.gameInvitationId,
      this.invitationStatus,
      this.friendId,
      this.friendStatus);

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

}