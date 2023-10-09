import 'package:sportper/domain/entities/sort_game.dart';

class FilterGame {
  String? startDate;
  String? endDate;
  int? numPlayers;
  int? numGuests;
  String? courseId;
  String? gameType;
  SortGame sort;

  FilterGame(this.startDate, this.endDate, this.numPlayers, this.numGuests,
      this.courseId, this.gameType, this.sort);

  bool get hasFilter => startDate != null || endDate != null || numGuests != null || numGuests != null || courseId != null;
}