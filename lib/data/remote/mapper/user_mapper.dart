import 'package:sportper/data/models/base_user_model.dart';
import 'package:sportper/data/models/user_model.dart';
import 'package:sportper/data/remote/mapper/course_mapper.dart';
import 'package:sportper/domain/entities/base_user.dart';
import 'package:sportper/domain/entities/signIn_method.dart';
import 'package:sportper/domain/entities/user.dart';

class UserMapper {
  CourseMapper _courseMapper = CourseMapper();

  SportperUser mapUser(UserModel? model) {
    return SportperUser(
        model?.id ?? '',
        model?.username ?? "",
        model?.fullName ?? "",
        model?.phoneNumber ?? "",
        model?.zipCode ?? "",
        model?.aboutMe ?? "",
        model?.fcmToken ?? "",
        model?.smoke ?? false,
        model?.gamble ?? false,
        model?.drink ?? false,
        model?.giveMe ?? false,
        model?.preferredTime.map((e) => e ?? "").toList() ?? [],
        mapSignMethod(model?.signInMethod ?? ""),
        model?.created ?? "",
        model?.avatar ?? "",
        model?.favourites?.map((e) => e ?? '').toList() ?? [],
        DateTime.tryParse(model?.birthday ?? ''),
        model?.handicap ?? 0,
        model?.course == null ? null : _courseMapper.mapCourse(model?.course),
        mapRole(model?.role));
  }

  SignInMethod mapSignMethod(String method) {
    switch (method) {
      case 'GOOGLE':
        return SignInMethod.google;
      case 'APPLE':
        return SignInMethod.apple;
    }
    return SignInMethod.email;
  }

  String reMapSigIn(SignInMethod method) {
    switch (method) {
      case SignInMethod.apple:
        return 'APPLE';
      case SignInMethod.email:
        return 'EMAIL';
      case SignInMethod.google:
        return 'GOOGLE';
    }
  }

  SportperUserRole mapRole(String? role) {
    if (role == 'ADMIN') {
      return SportperUserRole.admin;
    }
    return SportperUserRole.user;
  }

  String reMapRole(SportperUserRole role) {
    switch (role) {
      case SportperUserRole.admin:
        return 'ADMIN';
      case SportperUserRole.user:
        return 'USER';
    }
  }

  UserModel reMapUser(SportperUser user, {bool isIncludeId = false}) {
    return UserModel(
        id: isIncludeId ? user.id : null,
        username: user.username,
        fullName: user.fullName,
        phoneNumber: user.phoneNumber,
        zipCode: user.zipCode,
        aboutMe: user.aboutMe,
        fcmToken: user.fcmToken,
        smoke: user.smoke,
        gamble: user.gamble,
        drink: user.drink,
        giveMe: user.giveMe,
        preferredTime: user.preferredTime,
        signInMethod: reMapSigIn(user.signInMethod),
        created: user.createdAt,
        avatar: user.avatar,
        favourites: user.favourites,
        birthday: null,
        handicap: user.handicap,
        course: null,
        role: reMapRole(user.role));
  }

  BaseUser mapBaseUser(BaseUserModel? model) {
    return BaseUser(model?.id ?? '', model?.fullName ?? '',
        model?.username ?? '', model?.avatar ?? '', model?.phoneNumber ?? '');
  }

  BaseUserModel reMapBaseUser(BaseUser user, {bool isIncludeId = false}) {
    return BaseUserModel(isIncludeId ? user.id : null, user.fullName,
        user.username, user.avatar, user.phone);
  }
}
