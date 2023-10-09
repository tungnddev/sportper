import 'package:characters/src/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportper/data/models/course_model.dart';
import 'package:sportper/domain/entities/course.dart';
import 'package:sportper/utils/pair.dart';

class CourseService {
  CourseService._privateConstructor();

  static const String COURSES_COLLECTION = "courses";

  static final CourseService instance = CourseService._privateConstructor();

  static final CollectionReference _coursesCollection =
      FirebaseFirestore.instance.collection(COURSES_COLLECTION);

  Future<Pair<List<CourseModel>, Map<String, dynamic>?>> getList(
      String keyword, int limit, Map<String, dynamic>? lastDocData) async {
    late Query query;
    if (keyword.isNotEmpty) {
      final strFrontCode = keyword.substring(0, keyword.length - 1);
      final strEndCode = keyword.characters.last;
      final limitKeyword =
          strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
      query = _coursesCollection
          .where('clubName', isGreaterThanOrEqualTo: keyword)
          .where('clubName', isLessThan: limitKeyword)
          .orderBy('clubName');
          // .orderBy('state');
    } else {
      query = _coursesCollection.orderBy('clubName');
      // query = _coursesCollection.orderBy('name').orderBy('state');
    }

    if (lastDocData != null) {
      query = query.startAfter([lastDocData['clubName']]);
      // query = query.startAfter([lastDocData['name'], lastDocData['state']]);
    }

    final snap = await query.limit(limit).get();
    final lastElement = snap.docs.isEmpty ? null : snap.docs.last.data() as Map<String, dynamic>;

    final convertList = snap.docs.map((e) {
      var model = CourseModel.fromJson(e.data() as Map<String, dynamic>);
      model.id = e.id;
      return model;
    }).toList();
    return Pair(convertList, lastElement);
  }

  Future<Pair<List<CourseModel>, Map<String, dynamic>?>> getListNew(
      String keyword, int limit, Map<String, dynamic>? lastDocData) async {
    int limitQuery = keyword.isEmpty ? limit : keyword.length * 6 * 30;
    List<CourseModel> listResult = [];
    int multiplier = 0;

    Map<String, dynamic>? currentLastElement;

    while (listResult.length < limit) {
      multiplier++;
      final limitQueryWithMultiplier = limitQuery * multiplier;

      var query =
          _coursesCollection.orderBy("clubName");
      if (currentLastElement != null) {
        query = query.startAfter([currentLastElement['clubName']]);
      } else if (lastDocData != null) {
        query = query.startAfter([lastDocData['clubName']]);
      }

      final snap = await query.limit(limitQueryWithMultiplier).get();

      currentLastElement = snap.docs.isEmpty
          ? null
          : snap.docs.last.data() as Map<String, dynamic>;

      final listMatch = snap.docs
          .map((e) {
            var model = CourseModel.fromJson(e.data() as Map<String, dynamic>);
            model.id = e.id;
            return model;
          })
          .where((element) =>
              element.clubName?.toLowerCase().contains(keyword.toLowerCase()) ==
              true)
          .toList();
      listResult.addAll(listMatch);
      if (snap.docs.length < limitQueryWithMultiplier) {
        print(
            'Fetch success ${snap.docs.length} items and ${listMatch.length} items match from firebase');
        break;
      }
      print(
          'Fetch success $limitQueryWithMultiplier items and ${listMatch.length} items match from firebase');
    }
    return Pair(listResult, currentLastElement);
  }

  Future<Pair<List<CourseModel>, Map<String, dynamic>?>> getListFull(
      String keyword, int limit, Map<String, dynamic>? lastDocData) async {
    List<CourseModel> listResult = [];

    Map<String, dynamic>? currentLastElement;

    while (listResult.length < limit) {

      var query =
      _coursesCollection;

      final snap = await query.get();

      currentLastElement = snap.docs.isEmpty
          ? null
          : snap.docs.last.data() as Map<String, dynamic>;

      final listMatch = snap.docs
          .map((e) {
        var model = CourseModel.fromJson(e.data() as Map<String, dynamic>);
        model.id = e.id;
        return model;
      })
          .where((element) =>
      element.clubName?.toLowerCase().contains(keyword.toLowerCase()) ==
          true)
          .toList();
      listResult.addAll(listMatch);
        print(
            'Fetch success ${snap.docs.length} items and ${listMatch.length} items match from firebase');
        break;
    }
    return Pair(listResult, currentLastElement);
  }
}
