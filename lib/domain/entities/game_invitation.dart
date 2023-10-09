import 'game.dart';

class GameInvitation {
  String id;
  String gameId;
  String gameTitle;
  String gameImage;
  DateTime gameStartTime;
  String senderId;
  String receiverId;
  DateTime createdAt;
  GameInvitationStatus status;
  String content;

  GameInvitation(this.id,
      this.gameId,
      this.gameTitle,
      this.gameImage,
      this.gameStartTime,
      this.senderId,
      this.receiverId,
      this.createdAt,
      this.status,
      this.content);

  factory GameInvitation.fromGame(Game game, String senderId, String receiverId,
      String senderName) =>
      GameInvitation(
          '',
          game.id,
          game.title,
          game.image,
          game.time,
          senderId,
          receiverId,
          DateTime.now(),
          GameInvitationStatus.pending,
          '$senderName has invited you to ${game.title} game');
}

enum GameInvitationStatus {
  pending,
  accepted,
  decline
}