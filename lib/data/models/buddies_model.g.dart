// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buddies_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuddiesModel _$BuddiesModelFromJson(Map<String, dynamic> json) {
  return BuddiesModel(
    json['id'] as String?,
    json['status'] as String?,
    json['fullName'] as String?,
    json['phoneNumber'] as String?,
    json['avatar'] as String?,
  )..createdAt = json['createdAt'] as String?;
}

Map<String, dynamic> _$BuddiesModelToJson(BuddiesModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['status'] = instance.status;
  val['fullName'] = instance.fullName;
  val['phoneNumber'] = instance.phoneNumber;
  val['avatar'] = instance.avatar;
  val['createdAt'] = instance.createdAt;
  return val;
}
