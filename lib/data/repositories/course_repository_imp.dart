import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportper/data/remote/mapper/course_mapper.dart';
import 'package:sportper/data/remote/services/course_service.dart';
import 'package:sportper/domain/entities/course.dart';
import 'package:sportper/domain/repositories/course_repository.dart';
import 'package:sportper/utils/pair.dart';

class CourseRepositoryImp extends CourseRepository {
  CourseRepositoryImp._privateConstructor();
  static final CourseRepository instance = CourseRepositoryImp._privateConstructor();

  CourseMapper mapper = CourseMapper();
  CourseService service = CourseService.instance;

  @override
  Future<Pair<List<Course>, Map<String, dynamic>?>> getListDoc(String keyword, int limit, Map<String, dynamic>? lastDocData) async {
    final listCourses = await service.getListFull(keyword, limit, lastDocData);
    final listCoursesMap = listCourses.first.map((e) => mapper.mapCourse(e)).toList();
    return Pair(listCoursesMap, listCourses.second);
  }

}