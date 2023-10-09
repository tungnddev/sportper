import 'package:json_annotation/json_annotation.dart';

part 'course_model.g.dart';

@JsonSerializable()
class CourseModel {
  String? address;
  String? city;
  String? clubName;
  String? state;
  @JsonKey(includeIfNull: false)
  String? id;
  dynamic longitude;
  dynamic latitude;


  CourseModel({this.address, this.city, this.clubName, this.state, this.id, this.latitude, this.longitude});

  factory CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseModelToJson(this);
}