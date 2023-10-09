import 'package:sportper/data/models/course_model.dart';
import 'package:sportper/domain/entities/course.dart';

class CourseMapper {
  CourseMapper._privateConstructor();

  static final CourseMapper _instance = CourseMapper._privateConstructor();

  factory CourseMapper() {
    return _instance;
  }

  Course mapCourse(CourseModel? model) {
    return Course(
        address: model?.address ?? '',
        id: model?.id ?? '',
        clubName: model?.clubName?.replaceAll('\n', '') ?? '',
        state: model?.state ?? '',
        city: model?.city ?? '',
        latitude: model?.latitude is double ? (model?.latitude) : 0,
        longitude: model?.longitude is double ? (model?.longitude) : 0);
  }

  CourseModel remapCourse(Course course, {bool isIncludeId = false}) {
    return CourseModel(
        id: isIncludeId ? course.id : null,
        state: course.state,
        city: course.city,
        clubName: course.clubName,
        address: course.address,
        latitude: course.latitude,
        longitude: course.longitude);
  }
}
