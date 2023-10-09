import 'package:sportper/domain/entities/buddies.dart';
import 'package:sportper/domain/entities/friend_with_game.dart';
import 'package:sportper/utils/pair.dart';

abstract class FriendRepository {
  Future<Pair<List<FriendWithGame>, Map<String, dynamic>?>> getListWithGame(int limit, Map<String, dynamic>? lastDocData);
  Future addOtherToUser(List<String> listOthers, String currentUser, DateTime lastDate);
  Future addUserToOther(List<String> listOthers, String currentUser, DateTime lastDate);
  Future<Pair<List<Buddies>, Map<String, dynamic>?>> getBuddies(int limit, Map<String, dynamic>? lastDocData);
  Future addBuddies(Buddies buddies);
  Future remoteBuddies(String id);
  Future<bool> isBuddyExist(String friendId);
  Future changeStatusFriend(String userId, String friendId, String status);
  Future<List<Buddies>> getBuddiesExist();
}