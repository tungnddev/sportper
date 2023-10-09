import 'package:sportper/domain/entities/notification.dart';

class NotificationChat {
  String gameId;
  DateTime createdAt;
  String lastMessage;
  String title;
  String image;

  NotificationChat(this.gameId, this.createdAt, this.lastMessage, this.title,
      this.image);
}