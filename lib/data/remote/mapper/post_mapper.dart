import 'package:sportper/data/models/comment_reply_model.dart';
import 'package:sportper/data/models/post_comment_model.dart';
import 'package:sportper/data/models/post_model.dart';
import 'package:sportper/data/remote/mapper/user_mapper.dart';
import 'package:sportper/domain/entities/comment.dart';
import 'package:sportper/domain/entities/post.dart';
import 'package:sportper/domain/entities/reply.dart';

class PostMapper {
  PostMapper._privateConstructor();

  static final PostMapper _instance = PostMapper._privateConstructor();

  factory PostMapper() {
    return _instance;
  }

  UserMapper userMapper = UserMapper();

  DateTime _defaultDate = DateTime(1970);

  Post mapPost(PostModel? model) {
    return Post(
        model?.id ?? '',
        model?.content ?? '',
        model?.image?.map((e) => e ?? '').toList() ?? [],
        model?.likeList?.map((e) => e ?? '').toList() ?? [],
        userMapper.mapBaseUser(model?.user),
        model?.userId ?? '',
        DateTime.tryParse(model?.createdAt ?? '')?.toLocal() ?? _defaultDate,
        mapType(model?.type),
        model?.commentCount ?? 0,
        model?.comments?.map((e) => mapComment(e)).toList() ?? []);
  }

  Comment mapComment(PostCommentModel? model) {
    return Comment(
        model?.id ?? '',
        model?.content ?? '',
        model?.image ?? '',
        model?.likeList?.map((e) => e ?? '').toList() ?? [],
        userMapper.mapBaseUser(model?.user),
        model?.userId ?? '',
        DateTime.tryParse(model?.createdAt ?? '')?.toLocal() ?? _defaultDate,
        model?.postId ?? '',
        model?.hasReply ?? false,
        model?.replies?.map((e) => mapReply(e)).toList() ?? []);
  }

  Reply mapReply(CommentReplyModel? model) {
    return Reply(
        model?.id ?? '',
        model?.content ?? '',
        model?.image ?? '',
        model?.likeList?.map((e) => e ?? '').toList() ?? [],
        userMapper.mapBaseUser(model?.user),
        model?.userId ?? '',
        DateTime.tryParse(model?.createdAt ?? '')?.toLocal() ?? _defaultDate,
        model?.commentId ?? '');
  }

  CommentReplyModel reMapReply(Reply reply) {
    return CommentReplyModel(
        null,
        reply.content,
        reply.image,
        reply.likeList,
        userMapper.reMapBaseUser(reply.user, isIncludeId: true),
        reply.userId,
        reply.createdAt.toUtc().toIso8601String(),
        reply.commentId);
  }

  PostCommentModel reMapComment(Comment comment) {
    return PostCommentModel(
        null,
        comment.content,
        comment.image,
        comment.likeList,
        userMapper.reMapBaseUser(comment.user, isIncludeId: true),
        comment.userId,
        comment.createdAt.toUtc().toIso8601String(),
        comment.postId,
        comment.hasReply);
  }

  PostModel reMapPost(Post post) {
    return PostModel(
        null,
        post.content,
        post.image,
        post.likeList,
        userMapper.reMapBaseUser(post.user, isIncludeId: true),
        post.userId,
        post.createdAt.toUtc().toIso8601String(),
        post.type == PostType.content ? 'CONTENT' : 'FEED',
        post.commentCount);
  }

  PostType mapType(String? type) {
    switch (type) {
      case 'CONTENT':
        return PostType.content;
      case 'FEED':
        return PostType.feed;
    }
    return PostType.feed;
  }
}
