import 'package:sportper/data/remote/mapper/friend_mapper.dart';
import 'package:sportper/data/remote/mapper/user_mapper.dart';
import 'package:sportper/data/remote/services/auth_service.dart';
import 'package:sportper/data/remote/services/notification_service.dart';
import 'package:sportper/data/remote/services/user_service.dart';
import 'package:sportper/domain/entities/buddies.dart';
import 'package:sportper/domain/entities/friend_with_game.dart';
import 'package:sportper/domain/repositories/friend_repository.dart';
import 'package:sportper/domain/request/request_notification_friends.dart';
import 'package:sportper/utils/pair.dart';

class FriendRepositoryImp extends FriendRepository {
  FriendRepositoryImp._privateConstructor();

  FriendMapper mapper = FriendMapper();
  UserMapper _userMapper = UserMapper();
  UserService _userService = UserService.instance;
  AuthService _authService = AuthService.instance;
  NotificationService _notificationService = NotificationService.instance;

  static final FriendRepository instance =
      FriendRepositoryImp._privateConstructor();

  @override
  Future<Pair<List<FriendWithGame>, Map<String, dynamic>?>> getListWithGame(
      int limit, Map<String, dynamic>? lastDocData) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return Pair([], null);
    final result =
        await _userService.getListWithGame(limit, lastDocData, currentUser.uid);
    final userList = await _userService
        .getUserByListId(result.first.map((e) => e.id ?? '').toList());
    final listFriendsWithGame = result.first
        .map((e) => mapper.mapFriendWithGame(
            e,
            _userMapper.mapUser(userList
                .firstWhere((element) => element.id == e.id, orElse: null))))
        .toList();
    return Pair(listFriendsWithGame, result.second);
  }

  @override
  Future addOtherToUser(
      List<String> listOthers, String currentUser, DateTime dateTime) async {
    for (var i = 0; i < listOthers.length; i++) {
      if (currentUser == listOthers[i]) return;
      await _userService.setFriendsWithGame(
          listOthers[i], currentUser, dateTime.toUtc().toIso8601String());
    }
  }

  @override
  Future addUserToOther(
      List<String> listOthers, String currentUser, DateTime dateTime) async {
    for (var i = 0; i < listOthers.length; i++) {
      if (currentUser == listOthers[i]) return;
      await _userService.setFriendsWithGame(
          currentUser, listOthers[i], dateTime.toUtc().toIso8601String());
    }
  }

  @override
  Future<Pair<List<Buddies>, Map<String, dynamic>?>> getBuddies(
      int limit, Map<String, dynamic>? lastDocData) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return Pair([], null);
    final result =
        await _userService.getBuddies(limit, lastDocData, currentUser.uid);
    final userListFetch = await _userService.getUserByListId(result.first
        .where((element) => element.status != FriendStatus.not_exist.raw())
        .map((e) => e.id ?? '')
        .toList());
    final listFriendsWithGame = result.first.map((e) {
      if (e.status == FriendStatus.not_exist.raw()) {
        return mapper.mapNotExistBuddies(e);
      } else {
        return mapper.mapExistBuddies(
            e,
            _userMapper.mapUser(userListFetch
                .firstWhere((element) => element.id == e.id, orElse: null)));
      }
    }).toList();
    return Pair(listFriendsWithGame, result.second);
  }

  @override
  Future addBuddies(Buddies buddies) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return;

    final request = mapper.mapToRequestAddBuddy(buddies);
    if (buddies.status == FriendStatus.not_exist) {
      await _userService.addBuddies(currentUser.uid, request);
    } else {
      await _userService.setBuddies(currentUser.uid, buddies.id, request);
    }
  }

  @override
  Future<bool> isBuddyExist(String friendId) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return false;

    final buddyModel =
        await _userService.getBuddyByFriendId(currentUser.uid, friendId);
    if (buddyModel == null) return false;

    final status = mapper.mapStatus(buddyModel.status);
    if (status == FriendStatus.accepted) return true;
    return false;
  }

  @override
  Future changeStatusFriend(
      String userId, String friendId, String status) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return false;
    await _userService.changeStatusBuddies(userId, friendId, status);
  }

  @override
  Future<List<Buddies>> getBuddiesExist() async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return [];

    final result = await _userService.getAllBuddiesExist(currentUser.uid);
    final userListFetch = await _userService.getUserByListId(result
        .where((element) => element.status != FriendStatus.not_exist.raw())
        .map((e) => e.id ?? '')
        .toList());
    final listFriendsWithGame = result.map((e) {
      return mapper.mapExistBuddies(
          e,
          _userMapper.mapUser(userListFetch
              .firstWhere((element) => element.id == e.id, orElse: null)));
    }).toList();
    return listFriendsWithGame;
  }

  @override
  Future remoteBuddies(String id) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return;
    await _userService.removeBuddies(currentUser.uid, id);
  }
}
