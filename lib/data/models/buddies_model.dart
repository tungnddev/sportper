import 'package:json_annotation/json_annotation.dart';
part 'buddies_model.g.dart';

@JsonSerializable()
class BuddiesModel {
  @JsonKey(includeIfNull: false)
  String? id;
  String? status;
  String? fullName;
  String? phoneNumber;
  String? avatar;
  String? createdAt;

  BuddiesModel(
      this.id, this.status, this.fullName, this.phoneNumber, this.avatar);

  factory BuddiesModel.fromJson(Map<String, dynamic> json) =>
      _$BuddiesModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuddiesModelToJson(this);
}