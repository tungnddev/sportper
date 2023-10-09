import 'package:bloc/bloc.dart';
import 'package:sportper/domain/entities/friend_with_game.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/friend_repository.dart';
import 'package:sportper/domain/repositories/game_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/pair.dart';

import 'event.dart';
import 'state.dart';

class GameWithBloc extends Bloc<GameWithEvent, GameWithState> {
  static const int LIMIT = 20;
  List<FriendGamesWithVM?> currentListGameWith = [];
  late bool canLoadMore;

  FriendRepository repository;

  Map<String, dynamic>? lastDocData;

  GameWithBloc(this.repository) : super(GameWithInitial());

  @override
  Stream<GameWithState> mapEventToState(GameWithEvent event) async* {
    if (event is GameWithFetch) {
      currentListGameWith = [];
      lastDocData = null;
      canLoadMore = true;
      yield GameWithLoading();
      yield* fetchGame();
    } else if (event is GameWithLoadMore) {
      if (!canLoadMore) return;
      currentListGameWith.add(null);
      yield GameWithFetchSuccessful(listVM: currentListGameWith);
      yield* fetchGame(isLoadMore: true);
    }
  }

  Stream<GameWithState> fetchGame({bool isLoadMore = false}) async* {
    try {
      List<FriendWithGame> friendFetch = [];

      final data = await repository.getListWithGame(LIMIT, lastDocData);
      lastDocData = data.second;
      canLoadMore = data.first.length >= LIMIT;
      if (isLoadMore) {
        currentListGameWith.removeLast();
      }
      currentListGameWith
          .addAll(data.first.map((e) => FriendGamesWithVM(e)).toList());
      if (currentListGameWith.isEmpty) {
        yield GameWithFetchEmpty();
      } else {
        yield GameWithFetchSuccessful(
          listVM: currentListGameWith,
        );
      }
    } catch (error) {
      yield GameWithFetchFailed(error: error);
    }
  }
}
