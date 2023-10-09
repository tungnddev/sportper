import 'package:sportper/data/models/course_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(includeIfNull: false)
  String? id;
  String? username;
  String? fullName;
  String? phoneNumber;
  String? zipCode;
  String? aboutMe;
  String? fcmToken;
  bool? smoke;
  bool? gamble;
  bool? drink;
  bool? giveMe;
  List<String?> preferredTime;
  String? signInMethod;
  String? created;
  String? avatar;
  List<String?>? favourites;
  String? birthday;
  int? handicap;
  CourseModel? course;
  String? role;

  UserModel(
      {this.id,
      this.username,
      this.fullName,
      this.phoneNumber,
      this.zipCode,
      this.aboutMe,
      this.fcmToken,
      this.smoke,
      this.gamble,
      this.drink,
      this.giveMe,
      this.preferredTime = const [],
      this.signInMethod,
      this.created,
      this.avatar,
      this.favourites = const [],
      this.birthday,
      this.handicap,
      this.course,
      this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
