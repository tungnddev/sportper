import 'base_user.dart';
import 'user.dart';

class Reply {
  String id;
  String content;
  String image;
  List<String> likeList;
  BaseUser user;
  String userId;
  DateTime createdAt;
  String commentId;

  Reply(this.id, this.content, this.image, this.likeList, this.user,
      this.userId, this.createdAt, this.commentId);

  factory Reply.fromLocal(
      String commentId, String text, String? image, SportperUser currentUser) =>
      Reply('', text, image ?? '', [], BaseUser.fromUser(currentUser),
          currentUser.id, DateTime.now(), commentId);
}
