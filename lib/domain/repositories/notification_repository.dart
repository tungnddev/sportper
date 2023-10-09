import 'package:sportper/data/models/notification_model.dart';
import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/domain/entities/notification_chat.dart';
import 'package:sportper/domain/entities/notification_friend.dart';
import 'package:sportper/domain/entities/notification_game.dart';
import 'package:sportper/domain/request/request_notification_chat.dart';
import 'package:sportper/domain/request/request_notification_friends.dart';
import 'package:sportper/domain/request/request_notification_game.dart';
import 'package:sportper/utils/pair.dart';

abstract class NotificationRepository {
  Future addNotificationFriend(String userId, String friendId, RequestNotificationFriendsModel request);
  Future addNotificationChatOld(List<String> userIds, String gameId, RequestNotificationChatModel model);
  Future addNotificationGameOld(String userId, String gameId, RequestNotificationGame request);
  Future<Pair<List<NotificationChat>, Map<String, dynamic>?>> getNotificationChats(int limit, Map<String, dynamic>? lastDocData);
  Future<Pair<List<NotificationFriend>, Map<String, dynamic>?>> getNotificationFriends(int limit, Map<String, dynamic>? lastDocData);
  Future<Pair<List<NotificationGame>, Map<String, dynamic>?>> getNotificationGames(int limit, Map<String, dynamic>? lastDocData);
  Future<List<NotificationGame>> getAllNotificationGames();
  Future<List<NotificationGame>> getAllScheduleNotificationGame();
  Future changeStatusNotificationFriend(String friendId, String status);

  Future addNotification(String userId, Notification model);
  Future setNotification(String userId, String docId, Notification model);
  Future<Pair<List<Notification>, Map<String, dynamic>?>> getNotifications(int limit, Map<String, dynamic>? lastDocData);
  Future acceptStatusNotificationFriend(String notificationId);
  Future declineStatusNotificationFriend(String notificationId);
  Future addNotificationChat(List<String> userIds, String gameId, Notification model);
  Future acceptNotificationInvitation(String notificationId);
  Future declineNotificationInvitation(String notificationId);
}