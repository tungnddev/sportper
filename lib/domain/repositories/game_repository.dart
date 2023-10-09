import 'package:sportper/domain/entities/filter_game.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/my_game_query_type.dart';
import 'package:sportper/utils/pair.dart';

abstract class GameRepository {
  Future<String> createGame(Game game);

  Future<Pair<List<Game>, Map<String, dynamic>?>> getListCanJoin(
      String keyword, int limit, Map<String, dynamic>? lastDocData, FilterGame filterGame);

  Future<Game> getGameDetail(String id);

  Future joinGame(String gameId, List<String> newListJoin);

  Future<Pair<List<Game>, Map<String, dynamic>?>> getListJoined(
      int limit, Map<String, dynamic>? lastDocData, MyGameQueryType queryType);

  Future<List<Game>> getListGames(List<String> gameIds);
}
