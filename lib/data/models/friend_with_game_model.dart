import 'package:json_annotation/json_annotation.dart';

part 'friend_with_game_model.g.dart';

@JsonSerializable()
class FriendsWithGameModel {
  @JsonKey(includeIfNull: false)
  String? id;
  String? lastPlayDate;

  FriendsWithGameModel({this.id, this.lastPlayDate});

  factory FriendsWithGameModel.fromJson(Map<String, dynamic> json) =>
      _$FriendsWithGameModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendsWithGameModelToJson(this);
}
