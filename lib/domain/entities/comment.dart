import 'package:sportper/domain/entities/base_user.dart';
import 'package:sportper/domain/entities/reply.dart';
import 'package:sportper/domain/entities/user.dart';

class Comment {
  String id;
  String content;
  String image;
  List<String> likeList;
  BaseUser user;
  String userId;
  DateTime createdAt;
  String postId;
  bool hasReply;
  List<Reply> replies;

  Comment(this.id, this.content, this.image, this.likeList, this.user,
      this.userId, this.createdAt, this.postId, this.hasReply, this.replies);

  factory Comment.fromLocal(
          String postId, String text, String? image, SportperUser currentUser) =>
      Comment('', text, image ?? '', [], BaseUser.fromUser(currentUser),
          currentUser.id, DateTime.now(), postId, false, []);
}
