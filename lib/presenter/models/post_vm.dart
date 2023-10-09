import 'package:sportper/domain/entities/post.dart';
import 'package:sportper/utils/extensions/extensions.dart';

class PostVM {
  Post entity;
  String get time => entity.createdAt.timeDifferenceFromNow;
  bool isLiked;
  int likeCount;

  PostVM(this.entity, this.isLiked, this.likeCount);
}