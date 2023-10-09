import 'package:sportper/domain/entities/course.dart';

class CourseVM {
  Course _course;

  CourseVM(this._course);

  factory CourseVM.fromModel(Course course) {
    return CourseVM(course);
  }

  // String get address => _course.address;

  String get name => _course.clubName;

  Course get course => _course;

}