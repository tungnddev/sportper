import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/utils/definded/const.dart';

import 'game.dart';
import 'game_invitation.dart';

class Notification {
  String id;
  String title;
  String subTitle;
  String image;
  NotificationType type;
  DateTime createdAt;
  String titleNotification;
  String bodyNotification;
  DateTime? gameStartTime;
  String? gameId;
  String? gameInvitationId;
  GameInvitationStatus? invitationStatus;
  String? friendId;
  NotificationFriendStatus? friendStatus;

  Notification(this.id, this.title, this.subTitle, this.image, this.type,
      this.createdAt, this.titleNotification, this.bodyNotification,
      {this.gameStartTime,
      this.gameId,
      this.gameInvitationId,
      this.invitationStatus,
      this.friendId,
      this.friendStatus});

  factory Notification.fromFriendRequest(
    SportperUser friend,
  ) =>
      Notification(
          '',
          friend.fullName,
          friend.phoneNumber,
          friend.avatar,
          NotificationType.friendNotification,
          DateTime.now(),
          'Sportper',
          'You have a new friend request',
          friendId: friend.id,
          friendStatus: NotificationFriendStatus.pending);

  factory Notification.fromChat(Game game, String lastMessage) => Notification(
        '',
        'New message from ${game.title}',
        lastMessage,
        game.image,
        NotificationType.chatNotification,
        DateTime.now(),
        'Sportper - ${game.title}',
        lastMessage,
        gameId: game.id,
        gameStartTime: game.time,
      );

  factory Notification.fromGame(Game game) => Notification(
        '',
        'Game ${game.title} upcoming',
        '',
        game.image,
        NotificationType.gameNotification,
        game.time.subtract(NotificationGameConst.duration),
        '',
        '',
        gameId: game.id,
        gameStartTime: game.time,
      );

  factory Notification.fromInvitation(
          String invitationId, GameInvitation invitation, String senderName) =>
      Notification(
          '',
          '${invitation.gameTitle}',
          '$senderName has invited you to ${invitation.gameTitle} game',
          invitation.gameImage,
          NotificationType.gameInvitation,
          DateTime.now(),
          'Sportper',
          '$senderName has invited you to ${invitation.gameTitle} game',
          gameId: invitation.gameId,
          gameStartTime: invitation.gameStartTime,
          gameInvitationId: invitationId,
          invitationStatus: invitation.status);

  factory Notification.fromGameRemove(Game game) => Notification(
        '',
        '${game.title}',
        'You have been removed from this game',
        game.image,
        NotificationType.gameRemoved,
        DateTime.now(),
        'Sportper',
        'You have been removed from ${game.title} game',
        gameId: '',
        gameStartTime: game.time,
      );
}

enum NotificationType {
  friendNotification,
  chatNotification,
  gameNotification,
  gameInvitation,
  gameRemoved
}

enum NotificationFriendStatus { pending, accepted, decline }
