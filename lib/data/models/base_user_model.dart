import 'package:json_annotation/json_annotation.dart';
part 'base_user_model.g.dart';

@JsonSerializable()
class BaseUserModel {
  @JsonKey(includeIfNull: false)
  String? id;
  String? fullName;
  String? username;
  String? avatar;
  String? phoneNumber;

  BaseUserModel(this.id, this.fullName, this.username, this.avatar, this.phoneNumber);

  factory BaseUserModel.fromJson(Map<String, dynamic> json) => _$BaseUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseUserModelToJson(this);

}