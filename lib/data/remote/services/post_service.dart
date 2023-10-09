import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportper/data/models/comment_reply_model.dart';
import 'package:sportper/data/models/post_comment_model.dart';
import 'package:sportper/data/models/post_model.dart';
import 'package:sportper/domain/entities/filter_post.dart';
import 'package:sportper/utils/pair.dart';

class PostService {
  PostService._privateConstructor();

  static final PostService instance = PostService._privateConstructor();

  static const String POSTS_COLLECTION = "posts";

  static const String COMMENT_COLLECTION = 'comments';

  static const String REPLY_COLLECTION = 'replies';

  static final CollectionReference _collection =
      FirebaseFirestore.instance.collection(POSTS_COLLECTION);

  Future<String> addPost(PostModel model) async {
    final doc = await _collection.add(model.toJson());
    return doc.id;
  }

  Future updatePost(String id, Map<String, dynamic> changeData) async {
    await _collection.doc(id).update(changeData);
  }

  Future<String> addComment(String postId, PostCommentModel model) async {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot =
          await transaction.get(_collection.doc(postId));

      int newCommentCount =
          (snapshot.data() as Map<String, dynamic>)['commentCount'] + 1;
      transaction
          .update(_collection.doc(postId), {'commentCount': newCommentCount});
      final newDoc =
          _collection.doc(postId).collection(COMMENT_COLLECTION).doc();
      transaction.set(newDoc, model.toJson());
      return newDoc.id;
    });
  }

  Future<String> addReply(
      String postId, String commentId, CommentReplyModel model) async {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot =
          await transaction.get(_collection.doc(postId));

      int newCommentCount =
          (snapshot.data() as Map<String, dynamic>)['commentCount'] + 1;
      transaction
          .update(_collection.doc(postId), {'commentCount': newCommentCount});

      transaction.update(
          _collection.doc(postId).collection(COMMENT_COLLECTION).doc(commentId),
          {'hasReply': true});

      final newDoc = _collection
          .doc(postId)
          .collection(COMMENT_COLLECTION)
          .doc(commentId)
          .collection(REPLY_COLLECTION)
          .doc();
      transaction.set(newDoc, model.toJson());
      return newDoc.id;
    });
  }

  Future<PostModel> getAPost(String id) async {
    final doc = await _collection.doc(id).get();
    final model = PostModel.fromJson(doc.data() as Map<String, dynamic>);
    model.id = doc.id;
    model.comments = await getAllComments(id);
    return model;
  }

  Future<Pair<List<PostModel>, Map<String, dynamic>?>> getList(
      int limit, Map<String, dynamic>? lastDocData, FilterPost filter) async {
    int limitQuery = !filter.hasFilter ? limit : 30;
    List<PostModel> listResult = [];
    int multiplier = 0;

    Map<String, dynamic>? currentLastElement;

    while (listResult.length < limit) {
      multiplier++;
      final limitQueryWithMultiplier = limitQuery * multiplier;

      var query = _collection
          .orderBy('createdAt', descending: true)
          .where('type', isEqualTo: filter.type);

      if (currentLastElement != null) {
        query = query.startAfter(
            [currentLastElement['createdAt'], currentLastElement['type']]);
      } else if (lastDocData != null) {
        query =
            query.startAfter([lastDocData['createdAt'], lastDocData['type']]);
      }

      final snap = await query.limit(limitQueryWithMultiplier).get();

      currentLastElement = snap.docs.isEmpty
          ? null
          : snap.docs.last.data() as Map<String, dynamic>;

      final listMatch = snap.docs.map((e) {
        var model = PostModel.fromJson(e.data() as Map<String, dynamic>);
        model.id = e.id;
        return model;
      }).where((element) {
        // filter
        if (filter.listUser != null) {
          return filter.listUser!.contains(element.userId);
        }
        return true;
      }).toList();
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

  Future<List<PostCommentModel>> getAllComments(String postId) async {
    List<PostCommentModel> listResult = [];
    final commentOfPost = await _collection
        .doc(postId)
        .collection(COMMENT_COLLECTION)
        .orderBy('createdAt')
        .get();
    for (var i = 0; i < commentOfPost.size; i++) {
      final doc = commentOfPost.docs[i];
      final commentModel = PostCommentModel.fromJson(doc.data());
      commentModel.id = doc.id;
      if (commentModel.hasReply == true) {
        final listReplies = await getAllReply(postId, doc.id);
        commentModel.replies = listReplies;
      }
      listResult.add(commentModel);
    }
    return listResult;
  }

  Future<List<CommentReplyModel>> getAllReply(
      String postId, String commentId) async {
    final replies = await _collection
        .doc(postId)
        .collection(COMMENT_COLLECTION)
        .doc(commentId)
        .collection(REPLY_COLLECTION)
        .orderBy('createdAt')
        .get();
    return replies.docs.map((e) {
      var model = CommentReplyModel.fromJson(e.data());
      model.id = e.id;
      return model;
    }).toList();
  }

  Future changeLikePost(String id, String userId, {bool like = true}) async {
    if (like) {
      return _collection.doc(id).update({
        'likeList': FieldValue.arrayUnion([userId])
      });
    } else {
      return _collection.doc(id).update({
        'likeList': FieldValue.arrayRemove([userId])
      });
    }
  }

  Future changeLikeComment(String postId, String commentId, String userId,
      {bool like = true}) async {
    if (like) {
      return _collection
          .doc(postId)
          .collection(COMMENT_COLLECTION)
          .doc(commentId)
          .update({
        'likeList': FieldValue.arrayUnion([userId])
      });
    } else {
      return _collection
          .doc(postId)
          .collection(COMMENT_COLLECTION)
          .doc(commentId)
          .update({
        'likeList': FieldValue.arrayRemove([userId])
      });
    }
  }

  Future changeLikeReply(
      String postId, String commentId, String replyId, String userId,
      {bool like = true}) async {
    DocumentReference documentReference = _collection
        .doc(postId)
        .collection(COMMENT_COLLECTION)
        .doc(commentId)
        .collection(REPLY_COLLECTION)
        .doc(replyId);
    if (like) {
      return documentReference.update({
        'likeList': FieldValue.arrayUnion([userId])
      });
    } else {
      return documentReference.update({
        'likeList': FieldValue.arrayRemove([userId])
      });
    }
  }
}
