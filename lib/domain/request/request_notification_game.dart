import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/utils/definded/const.dart';

class RequestNotificationGame {
  DateTime createdAt;
  DateTime gameStartTime;
  String title;
  String image;
  String type;

  RequestNotificationGame(
      this.createdAt, this.gameStartTime, this.title, this.image, this.type);

  factory RequestNotificationGame.fromGameUpComing(Game game) {
    return RequestNotificationGame(
        game.time.subtract(NotificationGameConst.duration),
        game.time,
        game.title,
        game.image,
        NotificationGameConst.TYPE_UPCOMING);
  }

  factory RequestNotificationGame.fromGameInvite(Game game) {
    return RequestNotificationGame(
        DateTime.now(),
        game.time,
        game.title,
        game.image,
        NotificationGameConst.TYPE_INVITED);
  }

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt.toUtc().toIso8601String(),
        'gameStartTime': gameStartTime.toUtc().toIso8601String(),
        'title': title,
        'image': image,
        'type': type
      };
}
