import 'package:sportper/data/models/notification_chat_model.dart';
import 'package:sportper/data/models/notification_friends_model.dart';
import 'package:sportper/data/models/notification_game_model.dart';
import 'package:sportper/data/models/notification_model.dart';
import 'package:sportper/data/remote/mapper/game_invitation_mapper.dart';
import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/domain/entities/notification_chat.dart';
import 'package:sportper/domain/entities/notification_friend.dart';
import 'package:sportper/domain/entities/notification_game.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/utils/definded/const.dart';

class NotificationMapper {
  NotificationMapper._privateConstructor();

  static final NotificationMapper _instance =
      NotificationMapper._privateConstructor();

  factory NotificationMapper() {
    return _instance;
  }

  DateTime _defaultDate = DateTime(1970);

  NotificationFriend mapNotificationFriend(
      NotificationFriendsModel? model, SportperUser user) {
    return NotificationFriend(
        DateTime.tryParse(model?.createdAt ?? '')?.toLocal() ?? _defaultDate,
        user,
        mapStatusNotificationFriend(model?.status));
  }

  StatusNotificationFriend mapStatusNotificationFriend(String? status) {
    switch (status) {
      case NotificationFriendStatusConst.PENDING:
        return StatusNotificationFriend.pending;
      case NotificationFriendStatusConst.DECLINE:
        return StatusNotificationFriend.decline;
      case NotificationFriendStatusConst.ACCEPTED:
        return StatusNotificationFriend.accepted;
    }
    return StatusNotificationFriend.pending;
  }

  NotificationFriendStatus mapStatus(String? status) {
    switch (status) {
      case NotificationFriendStatusConst.PENDING:
        return NotificationFriendStatus.pending;
      case NotificationFriendStatusConst.DECLINE:
        return NotificationFriendStatus.decline;
      case NotificationFriendStatusConst.ACCEPTED:
        return NotificationFriendStatus.accepted;
    }
    return NotificationFriendStatus.pending;
  }

  String? reMapFriendStatus(NotificationFriendStatus? status) {
    switch (status) {
      case NotificationFriendStatus.pending:
        return NotificationFriendStatusConst.PENDING;
      case NotificationFriendStatus.decline:
        return NotificationFriendStatusConst.DECLINE;
      case NotificationFriendStatus.accepted:
        return NotificationFriendStatusConst.ACCEPTED;
      case null:
        return null;
    }
  }

  NotificationChat mapNotificationChat(NotificationChatModel? model) {
    return NotificationChat(
        model?.gameId ?? '',
        DateTime.tryParse(model?.createdAt ?? '')?.toLocal() ?? _defaultDate,
        model?.lastMessage ?? '',
        model?.title ?? '',
        model?.image ?? '');
  }

  NotificationGame mapNotificationGame(NotificationGameModel? model) {
    return NotificationGame(
      DateTime.tryParse(model?.createdAt ?? '')?.toLocal() ?? _defaultDate,
      model?.gameId ?? '',
      model?.image ?? '',
      DateTime.tryParse(model?.gameStartTime ?? '')?.toLocal() ?? _defaultDate,
      model?.title ?? '',
    );
  }

  Notification mapNotification(NotificationModel? model) {
    return Notification(
        model?.id ?? '',
        model?.title ?? '',
        model?.subTitle ?? '',
        model?.image ?? '',
        mapNotificationType(model?.type),
        DateTime.tryParse(model?.createdAt ?? '')?.toLocal() ?? _defaultDate,
        model?.titleNotification ?? '',
        model?.bodyNotification ?? '',
        gameStartTime: DateTime.tryParse(model?.gameStartTime ?? '')?.toLocal(),
        gameId: model?.gameId,
        gameInvitationId: model?.gameInvitationId,
        friendId: model?.friendId,
        friendStatus: mapStatus(model?.friendStatus),
        invitationStatus: GameInvitationMapper().mapStatus(model?.invitationStatus));
  }

  NotificationModel reMapNotification(Notification model, {bool isIncludeId = false}) {
    return NotificationModel(
        isIncludeId ? model.id : null,
        model.title,
        model.subTitle,
        model.image,
        reMapNotificationType(model.type),
        model.createdAt.toUtc().toIso8601String(),
        model.titleNotification,
        model.bodyNotification,
        model.gameStartTime?.toUtc().toIso8601String(),
        model.gameId,
        model.gameInvitationId,
        model.invitationStatus == null ? null : GameInvitationMapper().remapStatus(model.invitationStatus!),
        model.friendId,
        reMapFriendStatus(model.friendStatus));
  }

  NotificationType mapNotificationType(String? type) {
    switch (type) {
      case NotificationTypeConst.CHAT_NOTIFICATION:
        return NotificationType.chatNotification;
      case NotificationTypeConst.FRIEND_NOTIFICATION:
        return NotificationType.friendNotification;
      case NotificationTypeConst.GAME_INVITATION:
        return NotificationType.gameInvitation;
      case NotificationTypeConst.GAME_NOTIFICATION:
        return NotificationType.gameNotification;
      case NotificationTypeConst.GAME_REMOVED:
        return NotificationType.gameRemoved;
    }
    return NotificationType.chatNotification;
  }

  String reMapNotificationType(NotificationType type) {
    switch (type) {
      case NotificationType.chatNotification:
        return NotificationTypeConst.CHAT_NOTIFICATION;
      case NotificationType.friendNotification:
        return NotificationTypeConst.FRIEND_NOTIFICATION;
      case  NotificationType.gameInvitation:
        return NotificationTypeConst.GAME_INVITATION;
      case NotificationType.gameNotification:
        return NotificationTypeConst.GAME_NOTIFICATION;
      case NotificationType.gameRemoved:
        return NotificationTypeConst.GAME_REMOVED;
    }
  }
}
