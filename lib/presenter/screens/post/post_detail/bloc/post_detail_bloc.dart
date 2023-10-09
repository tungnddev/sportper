import 'package:bloc/bloc.dart';
import 'package:sportper/domain/entities/comment.dart';
import 'package:sportper/domain/entities/reply.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/post_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/comment_vm.dart';
import 'package:sportper/presenter/models/post_detail_vm.dart';
import 'package:sportper/presenter/models/reply_vm.dart';
import 'package:collection/collection.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/pair.dart';

import 'post_detail_event.dart';
import 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailVM? lastPostVM;

  PostRepository repository;
  UserRepository userRepository;
  AuthRepository authRepository;

  final String postId;
  SportperUser? currentUser;

  PostDetailBloc(
      this.repository, this.postId, this.userRepository, this.authRepository)
      : super(PostDetailInitial());

  @override
  Stream<PostDetailState> mapEventToState(PostDetailEvent event) async* {
    if (event is PostDetailInitData) {
      yield PostDetailLoading();
      currentUser = await userRepository.getCurrentUser();
      yield* fetchPost();
    } else if (event is PostDetailChangeFavourite) {
      yield* changeFavourite(event.id);
    } else if (event is PostDetailLikeComment) {
      yield* changeFavouriteComment(event.postId, event.commentId);
    } else if (event is PostDetailLikeReply) {
      yield* changeFavouriteReply(event.postId, event.commentId, event.replyId);
    } else if (event is PostDetailAddComment) {
      yield* addComment(event);
    }
  }

  Stream<PostDetailState> fetchPost() async* {
    try {
      final userId = (await authRepository.currentUser())?.uid ?? '';

      final data = await repository.getDetail(postId);

      lastPostVM = PostDetailVM(
          data,
          data.likeList.contains(userId),
          data.likeList.length,
          data.comments
              .map((e) => CommentVM(
                  e,
                  e.likeList.contains(userId),
                  e.likeList.length,
                  e.replies
                      .map((reply) => ReplyVM(
                          reply,
                          reply.likeList.contains(userId),
                          reply.likeList.length))
                      .toList()))
              .toList());
      yield PostDetailFetchSuccessful(
        vm: lastPostVM!,
      );
    } catch (error) {
      yield PostDetailFetchFailed(error: error);
    }
  }

  Stream<PostDetailState> changeFavourite(String id) async* {
    try {
      yield PostDetailShowLoading(isShowIndicator: false);
      await repository.changeLikePost(id, like: !lastPostVM!.isLiked);
      if (lastPostVM!.isLiked) {
        lastPostVM!.likeCount--;
        lastPostVM!.isLiked = false;
      } else {
        lastPostVM!.likeCount++;
        lastPostVM!.isLiked = true;
      }
      yield PostDetailHideLoading();
      yield PostDetailFetchSuccessful(
        vm: lastPostVM!,
      );
      // notifier

      RxBusService().add(RxBusName.CHANGE_LIKE_POST, value: Pair(id, lastPostVM!.isLiked));
      RxBusService().add(RxBusName.CHANGE_NUM_LIKE_POST, value: Pair(id, lastPostVM!.likeCount));
    } catch (error) {
      yield PostDetailHideLoading();
      yield PostDetailFetchFailed(error: error);
    }
  }

  Stream<PostDetailState> changeFavouriteComment(String postId, String commentId) async* {
    try {
      yield PostDetailShowLoading(isShowIndicator: false);
      final currentComment = lastPostVM!.comments.firstWhereOrNull((element) => element.entity.id == commentId);
      if (currentComment == null) return;
      await repository.changeLikeComment(postId, commentId, like: !currentComment.isLiked);
      if (currentComment.isLiked) {
        currentComment.likeCount--;
        currentComment.isLiked = false;
      } else {
        currentComment.likeCount++;
        currentComment.isLiked = true;
      }
      yield PostDetailHideLoading();
      yield PostDetailFetchSuccessful(
        vm: lastPostVM!,
      );
    } catch (error) {
      yield PostDetailHideLoading();
      yield PostDetailFetchFailed(error: error);
    }
  }

  Stream<PostDetailState> changeFavouriteReply(String postId, String commentId, String replyId) async* {
    try {
      yield PostDetailShowLoading(isShowIndicator: false);
      final currentReply = lastPostVM!.comments.firstWhereOrNull((element) => element.entity.id == commentId)?.replies.firstWhereOrNull((element) => element.entity.id == replyId);
      if (currentReply == null) return;
      await repository.changeLikeReply(postId, commentId, replyId, like: !currentReply.isLiked);
      if (currentReply.isLiked) {
        currentReply.likeCount--;
        currentReply.isLiked = false;
      } else {
        currentReply.likeCount++;
        currentReply.isLiked = true;
      }
      yield PostDetailHideLoading();
      yield PostDetailFetchSuccessful(
        vm: lastPostVM!,
      );
    } catch (error) {
      yield PostDetailHideLoading();
      yield PostDetailFetchFailed(error: error);
    }
  }

  Stream<PostDetailState> addComment(PostDetailAddComment event) async* {
    try {
      yield PostDetailShowLoading();
      if (currentUser == null) return;

      if (event.currentReplyVM == null) {
        final comment = Comment.fromLocal(postId, event.commentText, event.image, currentUser!);
        final id = await repository.addComment(postId, comment);
        comment.id = id;
        lastPostVM!.comments.add(CommentVM(comment, false, 0, []));
        lastPostVM!.entity.commentCount++;
      } else {
        final commentId = event.currentReplyVM!.commentId;
        final reply = Reply.fromLocal(commentId, event.commentText, event.image, currentUser!);
        final id = await repository.addReply(postId, commentId, reply);
        reply.id = id;
        final commentVM = lastPostVM!.comments.firstWhereOrNull((element) => element.entity.id == commentId);
        if (commentVM == null) {
          yield PostDetailHideLoading();
          return;
        }
        commentVM.replies.add(ReplyVM(reply, false, 0));
        lastPostVM!.entity.commentCount++;
      }

      yield PostDetailHideLoading();
      yield PostDetailFetchSuccessful(
        vm: lastPostVM!,
      );
      yield PostDetailAddCommentSuccessful();

      // notifier
      RxBusService().add(RxBusName.CHANGE_NUM_COMMENT_POST, value: Pair(postId, lastPostVM!.entity.commentCount));
    } catch (error) {
      yield PostDetailHideLoading();
      yield PostDetailFetchFailed(error: error);
    }
  }
}
