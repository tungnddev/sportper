import 'package:sportper/domain/entities/comment.dart';
import 'package:sportper/presenter/models/reply_vm.dart';
import 'package:sportper/utils/extensions/date.dart';

class CommentVM {
  Comment entity;
  bool isLiked;
  int likeCount;
  List<ReplyVM> replies;

  String get time => entity.createdAt.timeDifferenceFromNow;

  CommentVM(this.entity, this.isLiked, this.likeCount, this.replies);
}