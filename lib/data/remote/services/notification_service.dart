import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportper/data/models/notification_chat_model.dart';
import 'package:sportper/data/models/notification_friends_model.dart';
import 'package:sportper/data/models/notification_game_model.dart';
import 'package:sportper/data/models/notification_model.dart';
import 'package:sportper/domain/entities/notification_chat.dart';
import 'package:sportper/domain/request/request_notification_chat.dart';
import 'package:sportper/domain/request/request_notification_friends.dart';
import 'package:sportper/domain/request/request_notification_game.dart';
import 'package:sportper/utils/definded/const.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';

class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService instance =
      NotificationService._privateConstructor();

  static const String USERS_COLLECTION = "users";

  static const String NOTIFICATION_FRIEND_COLLECTION = 'friendNotifications';

  static const String NOTIFICATION_CHAT_COLLECTION = 'chatNotifications';

  static const String NOTIFICATION_GAME_COLLECTION = 'gameNotifications';

  static const String NOTIFICATION_COLLECTION = 'notifications';

  static final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);

  Future addFriendNotification(
      String userId, String friendId, RequestNotificationFriendsModel model) {
    return _userCollection
        .doc(userId)
        .collection(NOTIFICATION_FRIEND_COLLECTION)
        .doc(friendId)
        .set(model.toJson());
  }

  Future addNotificationChat(
      String userId, RequestNotificationChatModel model, String gameId) {
    return _userCollection
        .doc(userId)
        .collection(NOTIFICATION_CHAT_COLLECTION)
        .doc(gameId)
        .set(model.toJson());
  }

  Future addNotificationGame(
      String userId, RequestNotificationGame model, String gameId) {
    return _userCollection
        .doc(userId)
        .collection(NOTIFICATION_GAME_COLLECTION)
        .doc(gameId)
        .set(model.toJson());
  }

  Future<Pair<List<NotificationChatModel>, Map<String, dynamic>?>>
      getNotificationChats(int limit, Map<String, dynamic>? lastDocData,
          String currentUid) async {
    var query = _userCollection
        .doc(currentUid)
        .collection(NOTIFICATION_CHAT_COLLECTION)
        .orderBy('createdAt', descending: true);

    if (lastDocData != null) {
      query = query.startAfter([lastDocData['createdAt']]);
    }

    final snap = await query.limit(limit).get();

    final currentLastElement = snap.docs.isEmpty ? null : snap.docs.last.data();

    final listMatch = snap.docs.map((e) {
      var model = NotificationChatModel.fromJson(e.data());
      model.gameId = e.id;
      return model;
    }).toList();

    return Pair(listMatch, currentLastElement);
  }

  Future<Pair<List<NotificationFriendsModel>, Map<String, dynamic>?>>
      getNotificationFriends(int limit, Map<String, dynamic>? lastDocData,
          String currentUid) async {
    var query = _userCollection
        .doc(currentUid)
        .collection(NOTIFICATION_FRIEND_COLLECTION)
        .where('status', isEqualTo: NotificationFriendStatusConst.PENDING)
        .orderBy('createdAt', descending: true);

    if (lastDocData != null) {
      query =
          query.startAfter([lastDocData['createdAt'], lastDocData['status']]);
    }

    final snap = await query.limit(limit).get();

    final currentLastElement = snap.docs.isEmpty ? null : snap.docs.last.data();

    final listMatch = snap.docs.map((e) {
      var model = NotificationFriendsModel.fromJson(e.data());
      model.id = e.id;
      return model;
    }).toList();

    return Pair(listMatch, currentLastElement);
  }

  Future<Pair<List<NotificationGameModel>, Map<String, dynamic>?>>
      getNotificationGames(int limit, Map<String, dynamic>? lastDocData,
          String currentUid) async {
    var query = _userCollection
        .doc(currentUid)
        .collection(NOTIFICATION_GAME_COLLECTION)
        .where('createdAt',
            isLessThan: DateTime.now().toUtc().toIso8601String())
        .orderBy('createdAt', descending: true);

    if (lastDocData != null) {
      query = query.startAfter([lastDocData['createdAt']]);
    }

    final snap = await query.limit(limit).get();

    final currentLastElement = snap.docs.isEmpty ? null : snap.docs.last.data();

    final listMatch = snap.docs.map((e) {
      var model = NotificationGameModel.fromJson(e.data());
      model.gameId = e.id;
      return model;
    }).toList();

    return Pair(listMatch, currentLastElement);
  }

  Future<List<NotificationGameModel>> getAllNotificationGames(
      String currentUid) async {
    var query = _userCollection
        .doc(currentUid)
        .collection(NOTIFICATION_GAME_COLLECTION)
        .where('createdAt',
            isLessThan: DateTime.now().toUtc().toIso8601String())
        .where('createdAt',
            isGreaterThan: DateTime.now()
                .subtract(NotificationGameConst.duration)
                .toUtc()
                .toIso8601String())
        .orderBy('createdAt', descending: true);

    final snap = await query.get();

    final listMatch = snap.docs.map((e) {
      var model = NotificationGameModel.fromJson(e.data());
      model.gameId = e.id;
      return model;
    }).toList();

    return listMatch;
  }

  Future changeStatusFriendNotification(
      String friendId, String userId, String status) {
    return _userCollection
        .doc(userId)
        .collection(NOTIFICATION_FRIEND_COLLECTION)
        .doc(friendId)
        .update({'status': status});
  }

  Future<List<NotificationGameModel>> getAllScheduleNotificationGame(
      String currentUid) async {
    var query = _userCollection
        .doc(currentUid)
        .collection(NOTIFICATION_GAME_COLLECTION)
        .where('createdAt',
            isGreaterThan: DateTime.now().toUtc().toIso8601String());

    final snap = await query.get();

    final listMatch = snap.docs.map((e) {
      var model = NotificationGameModel.fromJson(e.data());
      model.gameId = e.id;
      return model;
    }).toList();

    return listMatch;
  }

  Future addNotification(String userId, NotificationModel model) {
    return _userCollection
        .doc(userId)
        .collection(NOTIFICATION_COLLECTION)
        .add(model.toJson());
  }

  Future setNotification(String userId, String id, NotificationModel model) {
    return _userCollection
        .doc(userId)
        .collection(NOTIFICATION_COLLECTION)
        .doc(id)
        .set(model.toJson());
  }

  Future<Pair<List<NotificationModel>, Map<String, dynamic>?>> getNotifications(
      int limit, Map<String, dynamic>? lastDocData, String currentUid) async {
    var query = _userCollection
        .doc(currentUid)
        .collection(NOTIFICATION_COLLECTION)
        .orderBy('createdAt', descending: true)
        .where('createdAt',
            isLessThan: DateTime.now().toUtc().toIso8601String());

    if (lastDocData != null) {
      query = query.startAfter([lastDocData['createdAt']]);
    }

    final snap = await query.limit(limit).get();

    final currentLastElement = snap.docs.isEmpty ? null : snap.docs.last.data();

    final listMatch = snap.docs.map((e) {
      var model = NotificationModel.fromJson(e.data());
      model.id = e.id;
      return model;
    }).toList();

    return Pair(listMatch, currentLastElement);
  }

  Future acceptNotificationFriendStatus(
      String userId, String id) async {
    await _userCollection
        .doc(userId)
        .collection(NOTIFICATION_COLLECTION)
        .doc(id)
        .update({
      "friendStatus": NotificationFriendStatusConst.ACCEPTED,
      "subTitle": Strings.friendAlreadyAccept
    });
  }
  Future declineNotificationFriendStatus(
      String userId, String id) async {
    await _userCollection
        .doc(userId)
        .collection(NOTIFICATION_COLLECTION)
        .doc(id)
        .update({
      "friendStatus": NotificationFriendStatusConst.DECLINE,
      "subTitle": Strings.friendAlreadyDecline
    });
  }

  Future acceptNotificationInvitation(
      String userId, String id) async {
    await _userCollection
        .doc(userId)
        .collection(NOTIFICATION_COLLECTION)
        .doc(id)
        .update({
      "invitationStatus": GameInvitationStatusConst.ACCEPTED,
      "subTitle": Strings.invitationAlreadyAccept
    });
  }
  Future declineNotificationInvitation(
      String userId, String id) async {
    await _userCollection
        .doc(userId)
        .collection(NOTIFICATION_COLLECTION)
        .doc(id)
        .update({
      "invitationStatus": GameInvitationStatusConst.DECLINE,
      "subTitle": Strings.invitationAlreadyDecline
    });
  }
}
