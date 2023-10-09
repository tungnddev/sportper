import 'package:sportper/domain/entities/course.dart';

import 'game_player.dart';

class Game {
  String id;
  String title;
  String subTitle;
  String image;
  bool isBooked;
  bool isTournament;
  String type;
  Course course;
  int numPlayers;
  int numGuests;
  List<GamePlayer> usersJoined;
  String createdBy;
  DateTime createdAt;
  DateTime time;
  bool smoke;
  bool gamble;
  bool drink;
  int minHandicap;
  int maxHandicap;
  GameHost host;

  Game(
      this.id,
      this.title,
      this.subTitle,
      this.image,
      this.isBooked,
      this.isTournament,
      this.type,
      this.course,
      this.numPlayers,
      this.numGuests,
      this.usersJoined,
      this.createdBy,
      this.createdAt,
      this.time,
      this.smoke,
      this.gamble,
      this.drink,
      this.minHandicap,
      this.maxHandicap,
      this.host);
}

class GameHost {
  String id;
  String fullName;
  String phoneNumber;
  String avatar;
  int handicap;
  int age;

  GameHost(this.id, this.fullName, this.avatar, this.phoneNumber, this.handicap, this.age);
}