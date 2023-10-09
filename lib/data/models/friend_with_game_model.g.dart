// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_with_game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendsWithGameModel _$FriendsWithGameModelFromJson(Map<String, dynamic> json) {
  return FriendsWithGameModel(
    id: json['id'] as String?,
    lastPlayDate: json['lastPlayDate'] as String?,
  );
}

Map<String, dynamic> _$FriendsWithGameModelToJson(
    FriendsWithGameModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['lastPlayDate'] = instance.lastPlayDate;
  return val;
}
