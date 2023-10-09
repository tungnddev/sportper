import 'package:sportper/data/models/notification_model.dart';
import 'package:sportper/data/remote/mapper/notification_mapper.dart';
import 'package:sportper/data/remote/mapper/user_mapper.dart';
import 'package:sportper/data/remote/services/auth_service.dart';
import 'package:sportper/data/remote/services/notification_service.dart';
import 'package:sportper/data/remote/services/user_service.dart';
import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/domain/entities/notification_chat.dart';
import 'package:sportper/domain/entities/notification_friend.dart';
import 'package:sportper/domain/entities/notification_game.dart';
import 'package:sportper/domain/repositories/notification_repository.dart';
import 'package:sportper/domain/request/request_notification_chat.dart';
import 'package:sportper/domain/request/request_notification_friends.dart';
import 'package:sportper/domain/request/request_notification_game.dart';
import 'package:sportper/utils/pair.dart';

class NotificationRepositoryImp extends NotificationRepository {
  NotificationRepositoryImp._privateConstructor();

  static final NotificationRepository instance =
      NotificationRepositoryImp._privateConstructor();

  NotificationService _service = NotificationService.instance;
  AuthService _authService = AuthService.instance;
  UserService _userService = UserService.instance;

  NotificationMapper mapper = NotificationMapper();
  UserMapper _userMapper = UserMapper();

  @override
  Future addNotificationFriend(
      String userId, String friendId, RequestNotificationFriendsModel request) {
    return _service.addFriendNotification(userId, friendId, request);
  }

  @override
  Future addNotificationChatOld(List<String> userIds, String gameId,
      RequestNotificationChatModel model) async {
    userIds.forEach((element) async {
      await _service.addNotificationChat(element, model, gameId);
    });
  }

  @override
  Future addNotificationGameOld(
      String userId, String gameId, RequestNotificationGame request) {
    return _service.addNotificationGame(userId, request, gameId);
  }

  @override
  Future<Pair<List<NotificationChat>, Map<String, dynamic>?>>
      getNotificationChats(int limit, Map<String, dynamic>? lastDocData) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return Pair([], null);

    final result = await _service.getNotificationChats(
        limit, lastDocData, currentUser.uid);
    final List<NotificationChat> notifications =
        result.first.map((e) => mapper.mapNotificationChat(e)).toList();

    return Pair(notifications, result.second);
  }

  @override
  Future<Pair<List<NotificationFriend>, Map<String, dynamic>?>>
      getNotificationFriends(
          int limit, Map<String, dynamic>? lastDocData) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return Pair([], null);
    final result = await _service.getNotificationFriends(
        limit, lastDocData, currentUser.uid);
    final userListFetch = await _userService
        .getUserByListId(result.first.map((e) => e.id ?? '').toList());
    final List<NotificationFriend> notifications = result.first.map((e) {
      return mapper.mapNotificationFriend(
          e,
          _userMapper.mapUser(userListFetch
              .firstWhere((element) => element.id == e.id, orElse: null)));
    }).toList();
    return Pair(notifications, result.second);
  }

  @override
  Future<Pair<List<NotificationGame>, Map<String, dynamic>?>>
      getNotificationGames(int limit, Map<String, dynamic>? lastDocData) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return Pair([], null);

    final result = await _service.getNotificationGames(
        limit, lastDocData, currentUser.uid);
    final List<NotificationGame> notifications =
        result.first.map((e) => mapper.mapNotificationGame(e)).toList();

    return Pair(notifications, result.second);
  }

  @override
  Future<List<NotificationGame>> getAllNotificationGames() async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return [];

    final result = await _service.getAllNotificationGames(currentUser.uid);
    final List<NotificationGame> notifications =
        result.map((e) => mapper.mapNotificationGame(e)).toList();

    return notifications;
  }

  @override
  Future changeStatusNotificationFriend(String friendId, String status) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return;

    await _service.changeStatusFriendNotification(
        friendId, currentUser.uid, status);
  }

  @override
  Future<List<NotificationGame>> getAllScheduleNotificationGame() async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return [];

    final result =
        await _service.getAllScheduleNotificationGame(currentUser.uid);
    final List<NotificationGame> notifications =
        result.map((e) => mapper.mapNotificationGame(e)).toList();
    return notifications;
  }

  @override
  Future addNotification(String userId, Notification model) {
    return _service.addNotification(userId, mapper.reMapNotification(model));
  }

  @override
  Future<Pair<List<Notification>, Map<String, dynamic>?>> getNotifications(
      int limit, Map<String, dynamic>? lastDocData) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return Pair([], null);
    final result =
        await _service.getNotifications(limit, lastDocData, currentUser.uid);
    final List<Notification> notifications = result.first.map((e) {
      return mapper.mapNotification(e);
    }).toList();
    return Pair(notifications, result.second);
  }

  @override
  Future setNotification(String userId, String docId, Notification model) {
    return _service.setNotification(
        userId, docId, mapper.reMapNotification(model));
  }

  @override
  Future acceptStatusNotificationFriend(String notificationId) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return;
    return _service.acceptNotificationFriendStatus(
        currentUser.uid, notificationId);
  }

  @override
  Future declineStatusNotificationFriend(String notificationId) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return;
    return _service.declineNotificationFriendStatus(
        currentUser.uid, notificationId);
  }

  @override
  Future addNotificationChat(
      List<String> userIds, String gameId, Notification model) async {
    userIds.forEach((element) async {
      await _service.setNotification(
          element, 'chat$gameId', mapper.reMapNotification(model));
    });
  }

  @override
  Future acceptNotificationInvitation(String notificationId) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return;
    return _service.acceptNotificationInvitation(
        currentUser.uid, notificationId);
  }

  @override
  Future declineNotificationInvitation(String notificationId) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return;
    return _service.declineNotificationInvitation(
        currentUser.uid, notificationId);
  }
}
