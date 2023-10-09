// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameModelFromJson(Map<String, dynamic> json) {
  return GameModel(
    id: json['id'] as String?,
    title: json['title'] as String?,
    subTitle: json['subTitle'] as String?,
    image: json['image'] as String?,
    isBooked: json['isBooked'] as bool?,
    isTournament: json['isTournament'] as bool?,
    type: json['type'] as String?,
    course: json['course'] == null
        ? null
        : CourseModel.fromJson(json['course'] as Map<String, dynamic>),
    numPlayers: json['numPlayers'] as int?,
    numGuests: json['numGuests'] as int?,
    usersJoined: (json['usersJoined'] as List<dynamic>?)
        ?.map((e) => e as String?)
        .toList(),
    createdBy: json['createdBy'] as String?,
    createdAt: json['createdAt'] as String?,
    time: json['time'] as String?,
    smoke: json['smoke'] as bool?,
    gamble: json['gamble'] as bool?,
    drink: json['drink'] as bool?,
    minHandicap: json['minHandicap'] as int?,
    maxHandicap: json['maxHandicap'] as int?,
    host: json['host'] == null
        ? null
        : GameHostedModel.fromJson(json['host'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GameModelToJson(GameModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['title'] = instance.title;
  val['subTitle'] = instance.subTitle;
  val['image'] = instance.image;
  val['isBooked'] = instance.isBooked;
  val['isTournament'] = instance.isTournament;
  val['type'] = instance.type;
  val['course'] = instance.course?.toJson();
  val['numPlayers'] = instance.numPlayers;
  val['numGuests'] = instance.numGuests;
  val['usersJoined'] = instance.usersJoined;
  val['createdBy'] = instance.createdBy;
  val['createdAt'] = instance.createdAt;
  val['time'] = instance.time;
  val['smoke'] = instance.smoke;
  val['gamble'] = instance.gamble;
  val['drink'] = instance.drink;
  val['minHandicap'] = instance.minHandicap;
  val['maxHandicap'] = instance.maxHandicap;
  val['host'] = instance.host?.toJson();
  return val;
}

GameHostedModel _$GameHostedModelFromJson(Map<String, dynamic> json) {
  return GameHostedModel(
    json['id'] as String?,
    json['fullName'] as String?,
    json['avatar'] as String?,
    json['phoneNumber'] as String?,
    json['handicap'] as int?,
    json['age'] as int?,
  );
}

Map<String, dynamic> _$GameHostedModelToJson(GameHostedModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'avatar': instance.avatar,
      'handicap': instance.handicap,
      'age': instance.age,
    };
