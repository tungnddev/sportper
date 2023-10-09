// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppErrorModel _$AppErrorModelFromJson(Map<String, dynamic> json) {
  return AppErrorModel(
    json['code'] as String,
    json['message'] as String,
  );
}

Map<String, dynamic> _$AppErrorModelToJson(AppErrorModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
