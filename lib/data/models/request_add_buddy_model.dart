import 'package:json_annotation/json_annotation.dart';
part 'request_add_buddy_model.g.dart';

@JsonSerializable()
class RequestAddBuddyModel {
  String? status;
  String? fullName;
  @JsonKey(includeIfNull: false)
  String? phoneNumber;
  @JsonKey(includeIfNull: false)
  String? avatar;
  String? createdAt;

  RequestAddBuddyModel(
      {required this.status, this.fullName, this.phoneNumber, this.avatar, required this.createdAt});

  Map<String, dynamic> toJson() => _$RequestAddBuddyModelToJson(this);
}