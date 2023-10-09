// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseUserModel _$BaseUserModelFromJson(Map<String, dynamic> json) {
  return BaseUserModel(
    json['id'] as String?,
    json['fullName'] as String?,
    json['username'] as String?,
    json['avatar'] as String?,
    json['phoneNumber'] as String?,
  );
}

Map<String, dynamic> _$BaseUserModelToJson(BaseUserModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['fullName'] = instance.fullName;
  val['username'] = instance.username;
  val['avatar'] = instance.avatar;
  val['phoneNumber'] = instance.phoneNumber;
  return val;
}
