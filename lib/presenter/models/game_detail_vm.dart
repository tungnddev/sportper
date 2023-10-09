import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/game_player.dart';
import 'package:sportper/utils/definded/const.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:intl/intl.dart';

class GameDetailVM {
  Game _game;
  bool isFavourite;
  bool canJoin;
  bool canInvite;
  bool showActions;
  List<PlayerVM> playerVMs;

  Game get game => _game;

  String get typeDisplay {
    switch (game.type) {
      case TypeConst.FOOT_BALL:
        return Strings.football;
      case TypeConst.BADMINTON:
        return Strings.badminton;
      case TypeConst.TENNIS:
        return Strings.tennis;
      case TypeConst.GOLF:
        return Strings.golf;
      case TypeConst.VOLLEYBALL:
        return Strings.volleyball;
      case TypeConst.BASKETBALL:
        return Strings.basketball;
    }
    return '';
  }

  String get phoneText => _game.host.phoneNumber.isEmpty ? Strings.notSet : _game.host.phoneNumber;

  String get timeDisplay => DateFormat('EEEE, dd MMM yyyy, hh:mm a', 'en').format(_game.time);

  int get remainingPlayer => _game.numPlayers - _game.usersJoined.length;

  String get joinText => '${_game.usersJoined.length}/${_game.numPlayers}';

  GameDetailVM(this._game, {required this.isFavourite, required this.canJoin, required this.canInvite, required this.showActions, required this.playerVMs});

}

class PlayerVM {
  GamePlayer entity;
  bool canDelete;

  PlayerVM(this.entity, this.canDelete);
}