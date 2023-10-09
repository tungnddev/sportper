import 'package:sportper/domain/entities/course.dart';

import 'signIn_method.dart';

class SportperUser {
  String id;
  String username;
  String fullName;
  String phoneNumber;
  String zipCode;
  String aboutMe;
  String fcmToken;
  bool smoke;
  bool gamble;
  bool drink;
  bool giveMe;
  List<String> preferredTime;
  SignInMethod signInMethod;
  String createdAt;
  String avatar;
  List<String> favourites;
  DateTime? birthday;
  int handicap;
  Course? course;
  SportperUserRole role;

  SportperUser(
      this.id,
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
      this.preferredTime,
      this.signInMethod,
      this.createdAt,
      this.avatar,
      this.favourites,
      this.birthday,
      this.handicap,
      this.course,
      this.role);
}

enum SportperUserRole {
  admin, user
}