import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:intl/intl.dart';

class GameVM {
  Game _game;
  bool isFavourite;
  double? distance;

  Game get game => _game;

  String get joinText => '${_game.usersJoined.length}/${_game.numPlayers}';

  String get timeDisplay => DateFormat('EEEE, dd MMM yyyy, hh:mm a', 'en').format(_game.time);

  GameVM(this._game, {required this.isFavourite, required this.distance});

  String get getAttributeText => '${Strings.drink}: ${_game.drink.value} - ${Strings.smoke}: ${_game.smoke.value} - ${Strings.gamble}: ${_game.gamble.value}';

  String get hostText => '${Strings.handicap}: ${_game.host.handicap} ${Strings.age}: ${_game.host.age}';
}

extension _Convert on bool {
  String get value => this ? Strings.yes : Strings.no;
}