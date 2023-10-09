import 'package:sportper/domain/entities/course.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/utils/pair.dart';

abstract class CourseRepository {
  Future<Pair<List<Course>, Map<String, dynamic>?>> getListDoc(String keyword, int limit, Map<String, dynamic>? lastDocData);
}