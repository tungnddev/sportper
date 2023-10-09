import 'dart:convert';

import 'package:characters/src/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportper/data/models/game_model.dart';
import 'package:sportper/domain/entities/filter_game.dart';
import 'package:sportper/domain/entities/my_game_query_type.dart';
import 'package:sportper/domain/entities/sort_game.dart';
import 'package:sportper/utils/pair.dart';

class GameService {
  GameService._privateConstructor();

  static const String GAMES_COLLECTION = "games";

  static final GameService instance = GameService._privateConstructor();

  static final CollectionReference _gameCollection =
      FirebaseFirestore.instance.collection(GAMES_COLLECTION);

  static const int MAX_IDS_PER_QUERY = 8;

  Future<String> createGame(GameModel model) async {
    final doc = await _gameCollection.add(model.toJson());
    return doc.id;
  }

  // Future<List<GameModel>> getList(String keyword, int limit,
  //     String? lastUid) async {
  //   int limitQuery = keyword.isEmpty ? limit : 20;
  //   List<GameModel> listResult = [];
  //   int multiplier = 1;
  //   while (listResult.length < limit) {
  //     final limitQueryWithMultiplier = limitQuery * multiplier;
  //
  //     var query = _gameCollection
  //         .orderBy(FieldPath.documentId);
  //     if (lastUid != null) {
  //       query = query.startAfter([lastUid]);
  //     }
  //     final snap = await query.limit(limitQueryWithMultiplier).get();
  //     final listMatch = snap.docs.map((e) {
  //       var model = GameModel.fromJson(e.data() as Map<String, dynamic>);
  //       model.id = e.id;
  //       return model;
  //     }).where((element) => element.title?.toLowerCase().contains(keyword.toLowerCase()) == true).toList();
  //     listResult.addAll(listMatch);
  //     print('Fetch success $limitQueryWithMultiplier items and ${listMatch.length} items match from firebase');
  //     if (snap.docs.length < limitQueryWithMultiplier) {
  //       break;
  //     }
  //   }
  //   return listResult;
  // }

  // Future<Pair<List<GameModel>, Map<String, dynamic>?>> getList(
  //     String keyword, int limit, Map<String, dynamic>? lastDocData) async {
  //   late Query query;
  //   if (keyword.isNotEmpty) {
  //     final strFrontCode = keyword.substring(0, keyword.length - 1);
  //     final strEndCode = keyword.characters.last;
  //     final limitKeyword =
  //         strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
  //     query = _gameCollection
  //         .where('name', isGreaterThanOrEqualTo: keyword)
  //         .where('name', isLessThan: limitKeyword)
  //         .orderBy('name');
  //   } else {
  //     query = _gameCollection.orderBy('createdAt', descending: true);
  //   }
  //
  //   if (lastDocData != null) {
  //     query = query.startAfter([lastDocData['createdAt']]);
  //   }
  //
  //   final snap = await query.limit(limit).get();
  //   final lastElement = snap.docs.isEmpty ? null : snap.docs.last.data() as Map<String, dynamic>;
  //
  //   final convertList = snap.docs.map((e) {
  //     var model = GameModel.fromJson(e.data() as Map<String, dynamic>);
  //     model.id = e.id;
  //     return model;
  //   }).toList();
  //   return Pair(convertList, lastElement);
  // }

  Future<Pair<List<GameModel>, Map<String, dynamic>?>> getList(
      String keyword,
      int limit,
      Map<String, dynamic>? lastDocData,
      String currentUid,
      FilterGame filterGame) async {
    int limitQuery = keyword.isEmpty || !filterGame.hasFilter ? limit : 30;
    List<GameModel> listResult = [];
    int multiplier = 0;

    Map<String, dynamic>? currentLastElement;

    while (listResult.length < limit) {
      multiplier++;
      final limitQueryWithMultiplier = limitQuery;

      var query = _gameCollection.orderBy('time').where('time',
          isGreaterThan: DateTime.now().toUtc().toIso8601String());

      if (filterGame.numPlayers != null) {
        query = query.where('numPlayers', isEqualTo: filterGame.numPlayers);
      }
      // if (filterGame.numGuests != null) {
      //   query = query.where('numGuests', isEqualTo: filterGame.numGuests);
      // }
      if (filterGame.gameType != null) {
        query = query.where('type', isEqualTo: filterGame.gameType);
      }

      if (currentLastElement != null) {
        query = query.startAfter([currentLastElement['time']]);
      } else if (lastDocData != null) {
        query = query.startAfter([lastDocData['time']]);
      }

      final snap = filterGame.sort == SortGame.daysAway
          ? await query.limit(limitQueryWithMultiplier).get()
          : await query.get();

      currentLastElement = snap.docs.isEmpty
          ? null
          : snap.docs.last.data() as Map<String, dynamic>;

      final listMatch = snap.docs
          .map((e) {
            var model = GameModel.fromJson(e.data() as Map<String, dynamic>);
            model.id = e.id;
            return model;
          })
          // search
          .where((element) =>
              element.title?.toLowerCase().contains(keyword.toLowerCase()) ==
              true)
          // not already joined
          .where(
              (element) => !(element.usersJoined?.contains(currentUid) == true))
          // not before now
          // .where((element) =>
          //     DateTime.tryParse(element.time ?? '')
          //         ?.toLocal()
          //         .isAfter(DateTime.now()) ==
          //     true)
          .where((element) {
            // filter
            bool filterStartDate = filterGame.startDate != null
                ? (element.time!.compareTo(filterGame.startDate!) >= 0)
                : true;
            bool filterEndDate = filterGame.endDate != null
                ? (element.time!.compareTo(filterGame.endDate!) <= 0)
                : true;
            bool filterCourse = filterGame.courseId != null
                ? (element.course?.id == filterGame.courseId)
                : true;
            return filterCourse && filterStartDate && filterEndDate;
          })
          .toList();
      listResult.addAll(listMatch);
      if (snap.docs.length < limitQueryWithMultiplier ||
          filterGame.sort == SortGame.distance) {
        print(
            'Fetch success ${snap.docs.length} items and ${listMatch.length} items match from firebase');
        break;
      }
      print(
          'Fetch success $limitQueryWithMultiplier items and ${listMatch.length} items match from firebase');
    }

    return Pair(listResult, currentLastElement);
  }

  Future<GameModel> getGameDetail(String id) async {
    final snap = await _gameCollection.doc(id).get();
    final model = GameModel.fromJson(snap.data() as Map<String, dynamic>);
    model.id = snap.id;
    return model;
  }

  Future join(String gameId, List<String> newJoined) async {
    await _gameCollection.doc(gameId).update({"usersJoined": newJoined});
  }

  Future<Pair<List<GameModel>, Map<String, dynamic>?>> getListJoined(
      int limit,
      Map<String, dynamic>? lastDocData,
      String currentUid,
      MyGameQueryType queryType) async {
    int limitQuery = 30;
    List<GameModel> listResult = [];
    int multiplier = 0;

    Map<String, dynamic>? currentLastElement;

    while (listResult.length < limit) {
      multiplier++;
      final limitQueryWithMultiplier = limitQuery;

      var query = _gameCollection.orderBy('time', descending: true);

      if (currentLastElement != null) {
        query = query.startAfter([currentLastElement['time']]);
      } else if (lastDocData != null) {
        query = query.startAfter([lastDocData['time']]);
      }

      final snap = await query.limit(limitQueryWithMultiplier).get();

      currentLastElement = snap.docs.isEmpty
          ? null
          : snap.docs.last.data() as Map<String, dynamic>;

      final listMatch = snap.docs
          .map((e) {
            var model = GameModel.fromJson(e.data() as Map<String, dynamic>);
            model.id = e.id;
            return model;
          })
          // check type
          .where((element) {
            switch (queryType) {
              case MyGameQueryType.upcoming:
                return DateTime.tryParse(element.time ?? '')
                        ?.toLocal()
                        .isAfter(DateTime.now()) ==
                    true;
              case MyGameQueryType.previous:
                return DateTime.tryParse(element.time ?? '')
                        ?.toLocal()
                        .isBefore(DateTime.now()) ==
                    true;
              case MyGameQueryType.favourite:
                return true;
            }
          })

          // already joined
          .where((element) => element.usersJoined?.contains(currentUid) == true)
          .toList();
      listResult.addAll(listMatch);
      if (snap.docs.length < limitQueryWithMultiplier) {
        print(
            'Fetch success ${snap.docs.length} items and ${listMatch.length} items match from firebase');
        break;
      }
      print(
          'Fetch success $limitQueryWithMultiplier items and ${listMatch.length} items match from firebase');
    }

    return Pair(listResult, currentLastElement);
  }

  // because firebase has limit 10 item each query array
  // we divide into many paths
  Future<List<GameModel>> getGamesByListId(List<String> ids) async {
    final times = (ids.length / MAX_IDS_PER_QUERY).ceil();
    List<GameModel> results = [];
    for (var i = 0; i < times; i++) {
      final startIndex = i * MAX_IDS_PER_QUERY;
      final endIndex = startIndex + MAX_IDS_PER_QUERY > ids.length
          ? ids.length
          : startIndex + MAX_IDS_PER_QUERY;
      final subList = ids.sublist(startIndex, endIndex);
      var elementResult = await _gameCollection
          .where(FieldPath.documentId, whereIn: subList)
          .get();
      final convertList = elementResult.docs.map((e) {
        var model = GameModel.fromJson(e.data() as Map<String, dynamic>);
        model.id = e.id;
        return model;
      }).toList();
      results.addAll(convertList);
    }
    return results;
  }
}
