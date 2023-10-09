import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sportper/domain/entities/course.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/my_game_query_type.dart';
import 'package:sportper/domain/repositories/game_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/screens/game/mygame/my_game_page.dart';
import 'package:sportper/presenter/screens/shared/location_service.dart';

import 'my_game_event.dart';
import 'my_game_state.dart';

class MyGameBloc extends Bloc<MyGameEvent, MyGameState> {
  static const int LIMIT = 8;
  List<GameVM?> currentListMyGame = [];
  late bool canLoadMore;

  GameRepository repository;
  UserRepository userRepository;

  Map<String, dynamic>? lastDocData;
  MyGameTab currentTab = MyGameTab.upcoming;

  MyGameBloc(this.repository, this.userRepository) : super(MyGameInitial());

  @override
  Stream<MyGameState> mapEventToState(MyGameEvent event) async* {
    if (event is MyGameFetch) {
      currentListMyGame = [];
      lastDocData = null;
      canLoadMore = true;
      yield MyGameLoading();
      yield* fetchGame();
    } else if (event is MyGameLoadMore) {
      if (!canLoadMore) return;
      currentListMyGame.add(null);
      yield MyGameFetchSuccessful(listMyGame: currentListMyGame);
      yield* fetchGame(isLoadMore: true);
    } else if (event is MyGameChangeFavourite) {
      yield* changeFavourite(event.id);
    } else if (event is MyGameChangeFavouriteFromDetail) {
      yield* changeFavouriteFromDetail(event.id, event.value);
    }
  }

  Stream<MyGameState> fetchGame({bool isLoadMore = false}) async* {
    try {
      final listFavourite =
          (await userRepository.getCurrentUser())?.favourites ?? [];
      final queryType = currentTab.getType();

      List<Game> gamesFetch = [];

      if (queryType == MyGameQueryType.upcoming ||
          queryType == MyGameQueryType.previous) {
        final data = await repository.getListJoined(
            LIMIT, lastDocData, currentTab.getType());
        gamesFetch = data.first;
        lastDocData = data.second;
        canLoadMore = gamesFetch.length >= LIMIT;
      } else {
        gamesFetch = await repository.getListGames(listFavourite);
        canLoadMore = false;
      }
      if (isLoadMore) {
        currentListMyGame.removeLast();
      }

      final currentLocation = await LocationService.instance.getCurrentPosition();

      currentListMyGame.addAll(gamesFetch
          .map((e) => GameVM(e, isFavourite: listFavourite.contains(e.id), distance: getDistanceMile(currentLocation, e.course)))
          .toList());
      if (currentListMyGame.isEmpty) {
        yield MyGameFetchEmpty();
      } else {
        yield MyGameFetchSuccessful(
          listMyGame: currentListMyGame,
        );
      }
    } catch (error) {
      yield MyGameFetchFailed(error: error);
    }
  }

  double? getDistanceMile(Position? currentLocation, Course course) {
    if ((course.latitude == 0 && course.longitude == 0) || currentLocation == null) return null;
    final distanceInMeters  = Geolocator.distanceBetween(
      course.latitude,
      course.longitude,
      currentLocation.latitude,
      currentLocation.longitude,
    );
    return distanceInMeters / 1609.344;
  }

  Stream<MyGameState> changeFavourite(String id) async* {
    try {
      final item = currentListMyGame
          .firstWhere((element) => element?.game.id == id, orElse: null);
      if (item == null) return;
      yield MyGameShowLoading();
      bool? result = item.isFavourite
          ? (await userRepository.removeFromFavourite(id))
          : (await userRepository.addToFavourite(id));
      if (result != null) {
        item.isFavourite = result;

        if (currentTab.getType() == MyGameQueryType.favourite && !result) {
          currentListMyGame.remove(item);
        }

        yield MyGameHideLoading();
        if (currentListMyGame.isEmpty) {
          yield MyGameFetchEmpty();
        } else {
          yield MyGameFetchSuccessful(
            listMyGame: currentListMyGame,
          );
        }
      }
    } catch (error) {
      yield MyGameHideLoading();
      yield MyGameFetchFailed(error: error);
    }
  }

  Stream<MyGameState> changeFavouriteFromDetail(String id, bool value) async* {
    try {
      if (value) {
        currentListMyGame = [];
        lastDocData = null;
        canLoadMore = true;
        yield MyGameLoading();
        yield* fetchGame();
        return;
      }
      final item = currentListMyGame
          .firstWhere((element) => element?.game.id == id, orElse: null);
      if (item == null || item.isFavourite == value) return;
      item.isFavourite = value;

      if (currentTab.getType() == MyGameQueryType.favourite && !value) {
        currentListMyGame.remove(item);
      }
      if (currentListMyGame.isEmpty) {
        yield MyGameFetchEmpty();
      } else {
        yield MyGameFetchSuccessful(
          listMyGame: currentListMyGame,
        );
      }
    } catch (error) {
      yield MyGameFetchFailed(error: error);
    }
  }
}

extension _Convert on MyGameTab {
  MyGameQueryType getType() {
    switch (this) {
      case MyGameTab.upcoming:
        return MyGameQueryType.upcoming;
      case MyGameTab.previous:
        return MyGameQueryType.previous;
      case MyGameTab.favourite:
        return MyGameQueryType.favourite;
    }
  }
}
