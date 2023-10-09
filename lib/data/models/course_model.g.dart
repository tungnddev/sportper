// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) {
  return CourseModel(
    address: json['address'] as String?,
    city: json['city'] as String?,
    clubName: json['clubName'] as String?,
    state: json['state'] as String?,
    id: json['id'] as String?,
    latitude: json['latitude'],
    longitude: json['longitude'],
  );
}

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) {
  final val = <String, dynamic>{
    'address': instance.address,
    'city': instance.city,
    'clubName': instance.clubName,
    'state': instance.state,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['longitude'] = instance.longitude;
  val['latitude'] = instance.latitude;
  return val;
}
