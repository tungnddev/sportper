import 'package:sportper/domain/entities/user.dart';

abstract class UserRepository {
  Future<SportperUser?> getUser(String id);

  Future addUser(String id, SportperUser user);

  Future updateFcmToken(String id, String fcmToken);

  Future logOut(String id);

  Future<bool> isValidUsername(String username);

  Future<bool> isValidPhone(String username);

  Future<SportperUser?> getCurrentUser();

  Future<bool?> addToFavourite(String gameId);

  Future<bool?> removeFromFavourite(String gameId);

  Future<SportperUser?> updateUser(Map<String, dynamic> data);

  Future<SportperUser?> getUserByPhone(String phone);

  Future<List<SportperUser>> getUsers(List<String> ids);

  Future<List<SportperUser>> getAllUser();
}