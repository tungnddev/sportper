import 'package:sportper/domain/entities/base_user.dart';
import 'package:sportper/domain/entities/user.dart';

import 'comment.dart';

class Post {
  String id;
  String content;
  List<String> image;
  List<String> likeList;
  BaseUser user;
  String userId;
  DateTime createdAt;
  PostType type;
  int commentCount;
  List<Comment> comments;

  Post(this.id, this.content, this.image, this.likeList, this.user, this.userId,
      this.createdAt, this.type, this.commentCount, this.comments);

  factory Post.fromLocal(
          String content, String? image, SportperUser currentUser, PostType type) =>
      Post(
          '',
          content,
          (image ?? '').isEmpty ? [] : [image ?? ''],
          [],
          BaseUser.fromUser(currentUser),
          currentUser.id,
          DateTime.now(),
          type,
          0,
          []);
}

enum PostType { feed, content }
