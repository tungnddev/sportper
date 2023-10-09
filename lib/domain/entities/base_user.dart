import 'package:sportper/domain/entities/user.dart';

class BaseUser {
  String id;
  String fullName;
  String username;
  String avatar;
  String phone;

  BaseUser(this.id, this.fullName, this.username, this.avatar, this.phone);

  factory BaseUser.fromUser(SportperUser user) => BaseUser(user.id, user.fullName, user.username, user.avatar, user.phoneNumber);

}