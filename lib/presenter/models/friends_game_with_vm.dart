import 'package:sportper/domain/entities/friend_with_game.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:intl/intl.dart';

class FriendGamesWithVM {
  FriendWithGame _friendWithGame;
  FriendGamesWithVM(this._friendWithGame);

  FriendWithGame get friendWithGame => _friendWithGame;

  String get fullName => _friendWithGame.user.fullName;
  String get phoneNumber => _friendWithGame.user.phoneNumber.isNotEmpty ? _friendWithGame.user.phoneNumber : Strings.noPhone;
  String get lastRoundText =>
      "${Strings.lastRoundPlayWith}: ${DateFormat('MM/dd/yyyy').format(_friendWithGame.lastDate)}";

}