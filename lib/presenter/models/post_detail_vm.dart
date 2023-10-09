import 'package:sportper/domain/entities/post.dart';
import 'package:sportper/presenter/models/comment_vm.dart';
import 'package:sportper/utils/extensions/date.dart';

class PostDetailVM {
  Post entity;
  String get time => entity.createdAt.timeDifferenceFromNow;
  bool isLiked;
  int likeCount;
  List<CommentVM> comments;


  PostDetailVM(this.entity, this.isLiked, this.likeCount, this.comments);
}