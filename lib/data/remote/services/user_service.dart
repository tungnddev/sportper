import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportper/data/models/buddies_model.dart';
import 'package:sportper/data/models/friend_with_game_model.dart';
import 'package:sportper/data/models/request_add_buddy_model.dart';
import 'package:sportper/data/models/user_model.dart';
import 'package:sportper/utils/pair.dart';

class UserService {
  UserService._privateConstructor();

  static const String USERS_COLLECTION = "users";

  static const String FRIENDS_WITH_GAME = "withGameFriends";

  static const String BUDDIES = "buddies";

  static const String PHONE_FIELD = "phoneNumber";

  static const String USERNAME_FIELD = "username";

  static const String FULL_NAME_FIELD = "fullName";

  static const int MAX_IDS_PER_QUERY = 8;

  static final UserService instance = UserService._privateConstructor();

  static final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);

  Future<UserModel?> getUserProfile(String id) async {
    final collection = await _userCollection.doc(id).get();
    if (collection.data() == null) return null;
    final user = UserModel.fromJson(collection.data() as Map<String, dynamic>);
    user.id = id;
    return user;
  }

  Future<UserModel?> getUserByFriend(String name, String phone) async {
    final query1 = await _userCollection
        .where(USERNAME_FIELD, isEqualTo: name)
        .where(PHONE_FIELD, isEqualTo: phone)
        .get();
    final query2 = await _userCollection
        .where(FULL_NAME_FIELD, isEqualTo: name)
        .where(PHONE_FIELD, isEqualTo: phone)
        .get();
    // final query2 =
    //     await _userCollection.where(USERNAME_FIELD, isEqualTo: name).get();
    // final query3 =
    //     await _userCollection.where(PHONE_FIELD, isEqualTo: phone).get();
    final merge = []
      ..addAll(query1.docs)
      ..addAll(query2.docs);
    // ..addAll(query3.docs);
    if (merge.isEmpty || merge[0].data() == null) return null;
    final user = UserModel.fromJson(merge[0].data() as Map<String, dynamic>);
    user.id = merge[0].id;
    return user;
  }

  Future createUser(String id, UserModel user) async {
    await _userCollection.doc(id).set(user.toJson());
  }

  Future updateUser(String id, Map<String, dynamic> changeDate) async {
    await _userCollection.doc(id).update(changeDate);
  }

  Future<UserModel?> getUserByUserName(String username) async {
    final collection =
        await _userCollection.where(USERNAME_FIELD, isEqualTo: username).get();
    if (collection.docs.isEmpty || collection.docs[0].data() == null)
      return null;
    final user =
        UserModel.fromJson(collection.docs[0].data() as Map<String, dynamic>);
    user.id = collection.docs[0].id;
    return user;
  }

  Future<UserModel?> getUserByPhone(String phone) async {
    final collection =
        await _userCollection.where(PHONE_FIELD, isEqualTo: phone).get();
    if (collection.docs.isEmpty || collection.docs[0].data() == null)
      return null;
    final user =
        UserModel.fromJson(collection.docs[0].data() as Map<String, dynamic>);
    user.id = collection.docs[0].id;
    return user;
  }

  Future<List<UserModel>> getUserByListId(List<String> ids) async {
    final times = (ids.length / MAX_IDS_PER_QUERY).ceil();
    List<UserModel> results = [];
    for (var i = 0; i < times; i++) {
      final startIndex = i * MAX_IDS_PER_QUERY;
      final endIndex = startIndex + MAX_IDS_PER_QUERY > ids.length
          ? ids.length
          : startIndex + MAX_IDS_PER_QUERY;
      final subList = ids.sublist(startIndex, endIndex);
      var elementResult = await _userCollection
          .where(FieldPath.documentId, whereIn: subList)
          .get();
      final convertList = elementResult.docs.map((e) {
        final userConvert =
            UserModel.fromJson(e.data() as Map<String, dynamic>);
        userConvert.id = e.id;
        return userConvert;
      }).toList();
      results.addAll(convertList);
    }
    return results;
  }

  Future<Pair<List<FriendsWithGameModel>, Map<String, dynamic>?>>
      getListWithGame(int limit, Map<String, dynamic>? lastDocData,
          String currentUid) async {
    var query = _userCollection
        .doc(currentUid)
        .collection(FRIENDS_WITH_GAME)
        .orderBy('lastPlayDate', descending: true);

    if (lastDocData != null) {
      query = query.startAfter([lastDocData['lastPlayDate']]);
    }

    final snap = await query.limit(limit).get();

    final currentLastElement = snap.docs.isEmpty ? null : snap.docs.last.data();

    final listMatch = snap.docs.map((e) {
      var model = FriendsWithGameModel.fromJson(e.data());
      model.id = e.id;
      return model;
    }).toList();

    return Pair(listMatch, currentLastElement);
  }

  Future setFriendsWithGame(String userId, String friendId, String date) async {
    await _userCollection
        .doc(userId)
        .collection(FRIENDS_WITH_GAME)
        .doc(friendId)
        .set({'lastPlayDate': date});
  }

  Future<Pair<List<BuddiesModel>, Map<String, dynamic>?>> getBuddies(
      int limit, Map<String, dynamic>? lastDocData, String currentUid) async {
    var query = _userCollection
        .doc(currentUid)
        .collection(BUDDIES)
        .orderBy('createdAt', descending: true);

    if (lastDocData != null) {
      query = query.startAfter([lastDocData['createdAt']]);
    }

    final snap = await query.limit(limit).get();

    final currentLastElement = snap.docs.isEmpty ? null : snap.docs.last.data();

    final listMatch = snap.docs.map((e) {
      var model = BuddiesModel.fromJson(e.data());
      model.id = e.id;
      return model;
    }).toList();

    return Pair(listMatch, currentLastElement);
  }

  Future<List<BuddiesModel>> getAllBuddiesExist(String currentUid) async {
    var query = _userCollection
        .doc(currentUid)
        .collection(BUDDIES)
        .where('status', isNotEqualTo: 'NOT_EXIST');

    final snap = await query.get();

    final listMatch = snap.docs.map((e) {
      var model = BuddiesModel.fromJson(e.data());
      model.id = e.id;
      return model;
    }).toList();

    return listMatch;
  }

  Future addBuddies(String currentUid, RequestAddBuddyModel model) {
    return _userCollection
        .doc(currentUid)
        .collection(BUDDIES)
        .add(model.toJson());
  }

  Future removeBuddies(String currentUid, String id) {
    return _userCollection
        .doc(currentUid)
        .collection(BUDDIES)
        .doc(id).delete();
  }

  Future setBuddies(
      String currentUid, String buddiesId, RequestAddBuddyModel model) {
    return _userCollection
        .doc(currentUid)
        .collection(BUDDIES)
        .doc(buddiesId)
        .set(model.toJson());
  }

  Future<BuddiesModel?> getBuddyByFriendId(
      String userId, String friendId) async {
    final collection = await _userCollection
        .doc(userId)
        .collection(BUDDIES)
        .doc(friendId)
        .get();
    if (collection.data() == null) return null;
    final user =
        BuddiesModel.fromJson(collection.data() as Map<String, dynamic>);
    user.id = friendId;
    return user;
  }

  Future changeStatusBuddies(String userId, String friendId, String status) {
    return _userCollection
        .doc(userId)
        .collection(BUDDIES)
        .doc(friendId)
        .update({'status': status});
  }

  Future<List<UserModel>> getAllUser() async {
    var elementResult = await _userCollection.get();
    final convertList = elementResult.docs.map((e) {
      final userConvert = UserModel.fromJson(e.data() as Map<String, dynamic>);
      userConvert.id = e.id;
      return userConvert;
    }).toList();
    return convertList;
  }
}
