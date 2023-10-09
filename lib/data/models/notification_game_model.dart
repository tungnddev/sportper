import 'package:json_annotation/json_annotation.dart';
part 'notification_game_model.g.dart';

@JsonSerializable()
class NotificationGameModel {
  String? createdAt;
  String? gameId;
  String? image;
  String? gameStartTime;
  String? title;

  NotificationGameModel(
      this.createdAt, this.gameId, this.image, this.gameStartTime, this.title);

  factory NotificationGameModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationGameModelFromJson(json);
}