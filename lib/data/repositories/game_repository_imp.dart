import 'package:sportper/data/models/user_model.dart';
import 'package:sportper/data/remote/mapper/game_mapper.dart';
import 'package:sportper/data/remote/services/auth_service.dart';
import 'package:sportper/data/remote/services/game_service.dart';
import 'package:sportper/data/remote/services/user_service.dart';
import 'package:sportper/domain/entities/filter_game.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/my_game_query_type.dart';
import 'package:sportper/domain/repositories/game_repository.dart';
import 'package:sportper/utils/pair.dart';

class GameRepositoryImp extends GameRepository {
  GameRepositoryImp._privateConstructor();

  static final GameRepositoryImp instance =
      GameRepositoryImp._privateConstructor();

  GameMapper mapper = GameMapper();
  GameService service = GameService.instance;
  UserService _userService = UserService.instance;
  AuthService _authService = AuthService.instance;

  @override
  Future<String> createGame(Game game) async {
    final gameModel = mapper.remapGameModel(game, isIncludeId: false);
    final id = await service.createGame(gameModel);
    return id;
  }

  @override
  Future<Pair<List<Game>, Map<String, dynamic>?>> getListCanJoin(
      String keyword, int limit, Map<String, dynamic>? lastDocData, FilterGame filterGame) async {
    final currentUid = (await _authService.currentUser())?.uid ?? '';
    final listAllUser = await _userService.getAllUser();

    final data = await service.getList(keyword, limit, lastDocData, currentUid, filterGame);
    final List<Game> listGameResult = [];
    for (var element in data.first) {
      final listUserIds = element.usersJoined ?? [];
      final List<UserModel> listUser = listUserIds.isNotEmpty
          ? (listAllUser.where((element) => listUserIds.contains(element.id)).toList())
          : [];
      listGameResult.add(mapper.mapGame(element, listUser));
    }
    return Pair(listGameResult, data.second);
  }

  @override
  Future<Game> getGameDetail(String id) async {
    final model = await service.getGameDetail(id);
    final listUserIds = model.usersJoined ?? [];
    final List<UserModel> listUser = listUserIds.isNotEmpty
        ? (await _userService
            .getUserByListId(listUserIds.map((e) => e ?? '').toList()))
        : [];
    return mapper.mapGame(model, listUser);
  }

  @override
  Future joinGame(String gameId, List<String> newListJoin) async {
    await service.join(gameId, newListJoin);
  }

  @override
  Future<Pair<List<Game>, Map<String, dynamic>?>> getListJoined(int limit,
      Map<String, dynamic>? lastDocData, MyGameQueryType queryType) async {
    final String userId = (await _authService.currentUser())?.uid ?? '';
    final data =
        await service.getListJoined(limit, lastDocData, userId, queryType);
    final List<Game> listGameResult = [];
    for (var element in data.first) {
      final listUserIds = element.usersJoined ?? [];
      final List<UserModel> listUser = listUserIds.isNotEmpty
          ? (await _userService
              .getUserByListId(listUserIds.map((e) => e ?? '').toList()))
          : [];
      listGameResult.add(mapper.mapGame(element, listUser));
    }
    return Pair(listGameResult, data.second);
  }

  // @override
  // Future<Pair<List<Game>, Map<String, dynamic>?>> getListJoinedPrevious(int limit, Map<String, dynamic>? lastDocData) async {
  //   final String userId = (await _authService.currentUser())?.uid ?? '';
  //   final data = await service.getListJoined(limit, lastDocData, userId, isPrevious: true);
  //   final List<Game> listGameResult = [];
  //   for (var element in data.first) {
  //     final listUserIds = element.usersJoined ?? [];
  //     final List<UserModel> listUser = listUserIds.isNotEmpty ? (await _userService.getUserByListId(listUserIds.map((e) => e ?? '').toList())) : [];
  //     listGameResult.add(mapper.mapGame(element, listUser));
  //   }
  //   return Pair(listGameResult, data.second);
  // }

  @override
  Future<List<Game>> getListGames(List<String> gameIds) async {
    final data = await service.getGamesByListId(gameIds);
    final List<Game> listGameResult = [];
    for (var element in data) {
      final listUserIds = element.usersJoined ?? [];
      final List<UserModel> listUser = listUserIds.isNotEmpty
          ? (await _userService
              .getUserByListId(listUserIds.map((e) => e ?? '').toList()))
          : [];
      listGameResult.add(mapper.mapGame(element, listUser));
    }
    return listGameResult;
  }
}
