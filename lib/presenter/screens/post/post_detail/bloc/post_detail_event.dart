import 'package:sportper/presenter/models/current_reply_vm.dart';

class PostDetailEvent {}

class PostDetailInitData extends PostDetailEvent {
  PostDetailInitData();
}

// class PostDetailFetch extends PostDetailEvent {
//   PostDetailFetch();
// }

class GameDetailJoin extends PostDetailEvent {}

class PostDetailChangeFavourite extends PostDetailEvent {
  String id;

  PostDetailChangeFavourite(this.id);
}

class PostDetailLikeComment extends PostDetailEvent {
  String commentId;
  String postId;

  PostDetailLikeComment({required this.commentId, required this.postId});
}

class PostDetailLikeReply extends PostDetailEvent {
  String commentId;
  String replyId;
  String postId;

  PostDetailLikeReply(
      {required this.commentId, required this.replyId, required this.postId});
}

class PostDetailAddComment extends PostDetailEvent {
  String commentText;
  String? image;
  CurrentReplyVM? currentReplyVM;

  PostDetailAddComment(
      {required this.commentText, this.image, this.currentReplyVM});
}
