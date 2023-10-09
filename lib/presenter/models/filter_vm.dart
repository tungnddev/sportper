import 'package:sportper/domain/entities/filter_game.dart';
import 'package:sportper/domain/entities/sort_game.dart';
import 'package:sportper/presenter/models/course_vm.dart';
import 'package:sportper/presenter/models/player_dropdown_vm.dart';
import 'package:sportper/presenter/screens/game/filter/widget/filter_choose_date_form_builder.dart';
import 'package:sportper/utils/definded/const.dart';

import 'type_option_vm.dart';

class FilterGameVM {
  FilterDateVM? filterDate;
  String? gameType;
  PlayerDropDownVM? numPlayers;
  PlayerDropDownVM? numGuests;
  CourseVM? selectedCourse;
  SortGame currentSort;

  FilterGameVM(
      {this.filterDate,
      this.gameType,
      this.numPlayers,
      this.numGuests,
      this.selectedCourse,
      required this.currentSort});

  factory FilterGameVM.fromMap(Map<String, dynamic> map) => FilterGameVM(
      filterDate: map['filterDate'],
      gameType: map['gameType'],
      numPlayers: map['numPlayers'],
      numGuests: map['numGuests'],
      selectedCourse: map['selectedCourse'],
      currentSort: map['sort']);

  int get positionGameType {
    if (gameType == null) return -1;
    if (gameType == TypeConst.FOOT_BALL) return 0;
    if (gameType == TypeConst.BADMINTON) return 1;
    if (gameType == TypeConst.TENNIS) return 2;
    if (gameType == TypeConst.GOLF) return 3;
    if (gameType == TypeConst.VOLLEYBALL) return 4;
    if (gameType == TypeConst.BASKETBALL) return 5;
    return -1;
  }

  FilterGame get entity => FilterGame(
      filterDate?.range.first.toUtc().toIso8601String(),
      filterDate?.range.second.toUtc().toIso8601String(),
      numPlayers?.number,
      numGuests?.number,
      selectedCourse?.course.id,
      gameType,
      currentSort);
}
