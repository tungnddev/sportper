import 'package:bloc/bloc.dart';
import 'package:sportper/domain/entities/course.dart';
import 'package:sportper/domain/repositories/course_repository.dart';
import 'package:sportper/presenter/models/course_vm.dart';

import 'course_event.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  static const int LIMIT = 15;
  List<CourseVM?> currentListCourse = [];
  late bool canLoadMore;

  CourseRepository repository;

  String lastKeyword = "";
  Map<String, dynamic>? lastDocData;

  CourseBloc(this.repository) : super(CourseInitial());

  @override
  Stream<CourseState> mapEventToState(CourseEvent event) async* {
    if (event is CourseFetch) {
      lastKeyword = event.keyword;
      currentListCourse = [];
      lastDocData = null;
      canLoadMore = true;
      yield CourseLoading();
      yield* fetchCourse();
    } else if (event is CourseLoadMore) {
      if (!canLoadMore) return;

      currentListCourse.add(null);
      yield CourseFetchSuccessful(listCourses: currentListCourse);
      yield* fetchCourse(isLoadMore: true);
    }
  }

  Stream<CourseState> fetchCourse({bool isLoadMore = false}) async* {
    try {
      final pair = await repository.getListDoc(lastKeyword, LIMIT, lastDocData);
      List<Course> courses = pair.first;
      lastDocData = pair.second;
      canLoadMore = courses.length >= LIMIT;
      if (isLoadMore) {
        currentListCourse.removeLast();
      }
      currentListCourse
          .addAll(courses.map((e) => CourseVM.fromModel(e)).toList());
      // currentListCourse
      //     .addAll(courses.where((element) => element.address.toLowerCase().contains(lastKeyword.toLowerCase())).map((e) => CourseVM.fromModel(e)).toList());
      if (currentListCourse.isEmpty) {
        yield CourseFetchEmpty();
      } else {
        yield CourseFetchSuccessful(
          listCourses: currentListCourse,
        );
      }
    } catch (error) {
      yield CourseFetchFailed(error: error);
    }
  }
}
