import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sportper/domain/entities/course.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/sort_game.dart';
import 'package:sportper/domain/repositories/game_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/filter_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/screens/shared/location_service.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/pair.dart';

import 'game_event.dart';
import 'game_state.dart';

class JoinBloc extends Bloc<JoinEvent, JoinState> {
  static const int LIMIT = 8;
  List<GameVM?> currentListJoin = [];
  late bool canLoadMore;

  GameRepository repository;
  UserRepository userRepository;

  String lastKeyword = "";
  Map<String, dynamic>? lastDocData;

  FilterGameVM currentFilter = FilterGameVM(currentSort: SortGame.daysAway);

  JoinBloc(this.repository, this.userRepository) : super(JoinInitial());

  @override
  Stream<JoinState> mapEventToState(JoinEvent event) async* {
    if (event is JoinFetch) {
      lastKeyword = event.keyword;
      currentListJoin = [];
      lastDocData = null;
      canLoadMore = true;
      yield JoinLoading();
      yield* fetchGame();
    } else if (event is JoinRefresh) {
      currentListJoin = [];
      lastDocData = null;
      canLoadMore = true;
      yield JoinLoading();
      yield* fetchGame();
    } else if (event is JoinLoadMore) {
      if (!canLoadMore) return;
      currentListJoin.add(null);
      yield JoinFetchSuccessful(listJoins: currentListJoin);
      yield* fetchGame(isLoadMore: true);
    } else if (event is JoinChangeFavourite) {
      yield* changeFavourite(event.id);
    } else if (event is JoinChangeFavouriteFromDetail) {
      yield* changeFavouriteFromDetail(event.id, event.value);
    }
  }

  Stream<JoinState> fetchGame({bool isLoadMore = false}) async* {
    try {
      final listFavourite =
          (await userRepository.getCurrentUser())?.favourites ?? [];

      final data = await repository.getListCanJoin(
          lastKeyword, LIMIT, lastDocData, currentFilter.entity);
      List<Game> games = data.first;
      lastDocData = data.second;
      canLoadMore = games.length >= LIMIT &&
          currentFilter.currentSort == SortGame.daysAway;
      if (isLoadMore) {
        currentListJoin.removeLast();
      }

      final currentLocation =
          await LocationService.instance.getCurrentPosition();

      currentListJoin.addAll(games
          .map((e) => GameVM(e,
              isFavourite: listFavourite.contains(e.id),
              distance: getDistanceMile(currentLocation, e.course)))
          .toList());
      if (currentFilter.currentSort == SortGame.distance) {
        currentListJoin.sort((first, second) {
          if (first?.distance == null) return 1;
          if (second?.distance == null) return -1;
          return Comparable.compare(
              first?.distance ?? 3, second?.distance ?? 3);
        });
      }
      if (currentListJoin.isEmpty) {
        yield JoinFetchEmpty();
      } else {
        yield JoinFetchSuccessful(
          listJoins: currentListJoin,
        );
      }
    } catch (error) {
      yield JoinFetchFailed(error: error);
    }
  }

  double? getDistanceMile(Position? currentLocation, Course course) {
    if ((course.latitude == 0 && course.longitude == 0) ||
        currentLocation == null) return null;
    final distanceInMeters = Geolocator.distanceBetween(
      course.latitude,
      course.longitude,
      currentLocation.latitude,
      currentLocation.longitude,
    );
    return distanceInMeters / 1609.344;
  }

  Stream<JoinState> changeFavourite(String id) async* {
    try {
      final item = currentListJoin
          .firstWhere((element) => element?.game.id == id, orElse: null);
      if (item == null) return;
      yield JoinShowLoading();
      bool? result = item.isFavourite
          ? (await userRepository.removeFromFavourite(id))
          : (await userRepository.addToFavourite(id));
      if (result != null) {
        item.isFavourite = result;
        yield JoinHideLoading();
        yield JoinFetchSuccessful(
          listJoins: currentListJoin,
        );
      }
    } catch (error) {
      yield JoinHideLoading();
      yield JoinFetchFailed(error: error);
    }
  }

  Stream<JoinState> changeFavouriteFromDetail(String id, bool value) async* {
    try {
      final item = currentListJoin
          .firstWhere((element) => element?.game.id == id, orElse: null);
      if (item == null || item.isFavourite == value) return;
      item.isFavourite = value;
      yield JoinFetchSuccessful(
        listJoins: currentListJoin,
      );
    } catch (error) {
      yield JoinFetchFailed(error: error);
    }
  }
}
