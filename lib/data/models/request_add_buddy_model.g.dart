// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_add_buddy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestAddBuddyModel _$RequestAddBuddyModelFromJson(Map<String, dynamic> json) {
  return RequestAddBuddyModel(
    status: json['status'] as String?,
    fullName: json['fullName'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    avatar: json['avatar'] as String?,
    createdAt: json['createdAt'] as String?,
  );
}

Map<String, dynamic> _$RequestAddBuddyModelToJson(
    RequestAddBuddyModel instance) {
  final val = <String, dynamic>{
    'status': instance.status,
    'fullName': instance.fullName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('phoneNumber', instance.phoneNumber);
  writeNotNull('avatar', instance.avatar);
  val['createdAt'] = instance.createdAt;
  return val;
}
