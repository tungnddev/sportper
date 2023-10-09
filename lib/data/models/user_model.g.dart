// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] as String?,
    username: json['username'] as String?,
    fullName: json['fullName'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    zipCode: json['zipCode'] as String?,
    aboutMe: json['aboutMe'] as String?,
    fcmToken: json['fcmToken'] as String?,
    smoke: json['smoke'] as bool?,
    gamble: json['gamble'] as bool?,
    drink: json['drink'] as bool?,
    giveMe: json['giveMe'] as bool?,
    preferredTime: (json['preferredTime'] as List<dynamic>)
        .map((e) => e as String?)
        .toList(),
    signInMethod: json['signInMethod'] as String?,
    created: json['created'] as String?,
    avatar: json['avatar'] as String?,
    favourites: (json['favourites'] as List<dynamic>?)
        ?.map((e) => e as String?)
        .toList(),
    birthday: json['birthday'] as String?,
    handicap: json['handicap'] as int?,
    course: json['course'] == null
        ? null
        : CourseModel.fromJson(json['course'] as Map<String, dynamic>),
    role: json['role'] as String?,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['username'] = instance.username;
  val['fullName'] = instance.fullName;
  val['phoneNumber'] = instance.phoneNumber;
  val['zipCode'] = instance.zipCode;
  val['aboutMe'] = instance.aboutMe;
  val['fcmToken'] = instance.fcmToken;
  val['smoke'] = instance.smoke;
  val['gamble'] = instance.gamble;
  val['drink'] = instance.drink;
  val['giveMe'] = instance.giveMe;
  val['preferredTime'] = instance.preferredTime;
  val['signInMethod'] = instance.signInMethod;
  val['created'] = instance.created;
  val['avatar'] = instance.avatar;
  val['favourites'] = instance.favourites;
  val['birthday'] = instance.birthday;
  val['handicap'] = instance.handicap;
  val['course'] = instance.course;
  val['role'] = instance.role;
  return val;
}
