import 'package:sportper/domain/entities/reply.dart';
import 'package:sportper/utils/extensions/date.dart';

class ReplyVM {

  bool isLiked;
  int likeCount;

  String get time => entity.createdAt.timeDifferenceFromNow;

  Reply entity;
  ReplyVM(this.entity, this.isLiked, this.likeCount);
}