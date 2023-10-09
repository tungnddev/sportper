import 'package:json_annotation/json_annotation.dart';

import 'base_user_model.dart';
import 'comment_reply_model.dart';
part 'post_comment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PostCommentModel {
  @JsonKey(includeIfNull: false)
  String? id;
  String? content;
  String? image;
  List<String?>? likeList;
  BaseUserModel? user;
  String? userId;
  String? createdAt;
  String? postId;
  bool? hasReply;
  @JsonKey(ignore: true)
  List<CommentReplyModel?>? replies;

  PostCommentModel(
      this.id, this.content, this.image, this.likeList, this.user, this.userId, this.createdAt, this.postId, this.hasReply);

  factory PostCommentModel.fromJson(Map<String, dynamic> json) => _$PostCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostCommentModelToJson(this);
}