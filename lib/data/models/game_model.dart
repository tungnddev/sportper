import 'package:json_annotation/json_annotation.dart';

import 'course_model.dart';

part 'game_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GameModel {
  @JsonKey(includeIfNull: false)
  String? id;
  String? title;
  String? subTitle;
  String? image;
  bool? isBooked;
  bool? isTournament;
  String? type;
  CourseModel? course;
  int? numPlayers;
  int? numGuests;
  List<String?>? usersJoined;
  String? createdBy;
  String? createdAt;
  String? time;
  bool? smoke;
  bool? gamble;
  bool? drink;
  int? minHandicap;
  int? maxHandicap;
  GameHostedModel? host;


  GameModel({this.id,
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
    this.host,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameModelToJson(this);
}

@JsonSerializable()
class GameHostedModel {
  String? id;
  String? fullName;
  String? phoneNumber;
  String? avatar;
  int? handicap;
  int? age;

  GameHostedModel(this.id, this.fullName, this.avatar, this.phoneNumber, this.handicap, this.age);

  factory GameHostedModel.fromJson(Map<String, dynamic> json) =>
      _$GameHostedModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameHostedModelToJson(this);
}
