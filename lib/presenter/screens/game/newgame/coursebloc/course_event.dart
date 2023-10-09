class CourseEvent {

}

class CourseFetch extends CourseEvent {
  final String keyword;
  CourseFetch({required this.keyword});
}

class CourseLoadMore extends CourseEvent {
  CourseLoadMore();
}