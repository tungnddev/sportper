import 'package:sportper/domain/entities/comment.dart';
import 'package:sportper/domain/entities/filter_post.dart';
import 'package:sportper/domain/entities/post.dart';
import 'package:sportper/domain/entities/reply.dart';
import 'package:sportper/utils/pair.dart';

abstract class PostRepository {
  Future<String> createPost(Post post);
  Future<Pair<List<Post>, Map<String, dynamic>?>> getList(
      int limit, Map<String, dynamic>? lastDocData, FilterPost filterPost);
  Future<Post> getDetail(String id);
  Future changeLikePost(String id, {bool like = true});
  Future changeLikeComment(String postId, String commentId, {bool like = true});
  Future changeLikeReply(String postId, String commentId, String replyId, {bool like = true});
  Future<String> addComment(String postId, Comment comment);
  Future<String> addReply(String postId, String commentId, Reply reply);
}
