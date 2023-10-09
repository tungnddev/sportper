import 'package:json_annotation/json_annotation.dart';

part 'app_error_model.g.dart';

@JsonSerializable()
class AppErrorModel {
  final String code;
  final String message;

  AppErrorModel(this.code, this.message);
  factory AppErrorModel.fromJson(Map<String, dynamic> json) =>
      _$AppErrorModelFromJson(json);
  Map<String, dynamic> toJson() => _$AppErrorModelToJson(this);
}
