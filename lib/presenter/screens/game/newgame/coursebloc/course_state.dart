import 'package:sportper/presenter/models/course_vm.dart';

class CourseState {

}


class CourseInitial extends CourseState {

}

class CourseLoading extends CourseState {
}

class CourseFetchSuccessful extends CourseState {
  final List<CourseVM?> listCourses;
  CourseFetchSuccessful({required this.listCourses});
}

class CourseFetchFailed extends CourseState {
  final Object error;
  CourseFetchFailed({required this.error});
}

class CourseFetchEmpty extends CourseState {
}


