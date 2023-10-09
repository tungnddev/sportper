import 'package:sportper/domain/entities/user.dart';

class FriendWithGame {
  SportperUser _user;
  DateTime lastDate;

  FriendWithGame(this._user, this.lastDate);

  SportperUser get user => _user;
}