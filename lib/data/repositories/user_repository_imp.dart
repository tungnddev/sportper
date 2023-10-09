import 'package:sportper/data/models/user_model.dart';
import 'package:sportper/data/remote/mapper/user_mapper.dart';
import 'package:sportper/data/remote/services/auth_service.dart';
import 'package:sportper/data/remote/services/user_service.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/user_repository.dart';

class UserRepositoryImp extends UserRepository {
  UserRepositoryImp._privateConstructor();

  UserMapper mapper = UserMapper();
  UserService service = UserService.instance;
  AuthService _authService = AuthService.instance;

  static final UserRepositoryImp instance =
      UserRepositoryImp._privateConstructor();

  Future<SportperUser?> getUser(String id) async {
    final userModel = await service.getUserProfile(id);
    if (userModel == null) return null;
    return mapper.mapUser(userModel);
  }

  Future addUser(String id, SportperUser user) {
    return service.createUser(id, mapper.reMapUser(user));
  }

  @override
  Future logOut(String id) async {
    return service.updateUser(id, {"fcmToken": ""});
  }

  @override
  Future updateFcmToken(String id, String fcmToken) {
    return service.updateUser(id, {"fcmToken": fcmToken});
  }

  @override
  Future<bool> isValidUsername(String username) {
    return service.getUserByUserName(username).then((value) => value == null);
  }

  @override
  Future<bool> isValidPhone(String phone) {
    return service.getUserByPhone(phone).then((value) => value == null);
  }

  @override
  Future<SportperUser?> getCurrentUser() async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return null;
    final userModel = await service.getUserProfile(currentUser.uid);
    if (userModel == null) return null;
    return mapper.mapUser(userModel);
  }

  @override
  Future<bool?> addToFavourite(String gameId) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return null;
    final userModel = await service.getUserProfile(currentUser.uid);
    if (userModel == null) return null;

    final currentFavourite =
        userModel.favourites?.map((e) => e ?? '').toList() ?? [];
    if (currentFavourite.contains(gameId)) return null;
    currentFavourite.add(gameId);
    await service.updateUser(currentUser.uid, {'favourites': currentFavourite});
    return true;
  }

  @override
  Future<bool?> removeFromFavourite(String gameId) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return null;
    final userModel = await service.getUserProfile(currentUser.uid);
    if (userModel == null) return null;

    final currentFavourite =
        userModel.favourites?.map((e) => e ?? '').toList() ?? [];
    if (!currentFavourite.contains(gameId)) return null;
    currentFavourite.remove(gameId);
    await service.updateUser(currentUser.uid, {'favourites': currentFavourite});
    return false;
  }

  @override
  Future<SportperUser?> updateUser(Map<String, dynamic> data) async {
    final currentUser = await _authService.currentUser();
    if (currentUser == null) return null;
    await service.updateUser(currentUser.uid, data);

    final userModel = await service.getUserProfile(currentUser.uid);
    if (userModel == null) return null;
    return mapper.mapUser(userModel);
  }

  @override
  Future<SportperUser?> getUserByPhone(String phone) async {
    final userModel = await service.getUserByPhone(phone);
    if (userModel == null) return null;
    return mapper.mapUser(userModel);
  }

  @override
  Future<List<SportperUser>> getUsers(List<String> ids) async {
    final userModel = await service.getUserByListId(ids);
    return userModel.map((e) => mapper.mapUser(e)).toList();
  }

  @override
  Future<List<SportperUser>> getAllUser() async {
    final userModel = await service.getAllUser();
    return userModel.map((e) => mapper.mapUser(e)).toList();
  }
}
