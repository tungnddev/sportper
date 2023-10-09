import 'package:sportper/domain/entities/game.dart';

class RequestNotificationChatModel {
  DateTime createdAt;
  String lastMessage;
  String title;
  String image;

  RequestNotificationChatModel(
      this.createdAt, this.lastMessage, this.title, this.image);

  factory RequestNotificationChatModel.fromContent(String lastMessage,  Game game) {
    return RequestNotificationChatModel(DateTime.now(), lastMessage, game.title, game.image);
  }

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt.toUtc().toIso8601String(),
    'lastMessage': lastMessage,
    'title': title,
    'image': image
  };
}
