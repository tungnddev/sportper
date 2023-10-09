import 'package:json_annotation/json_annotation.dart';

import 'base_user_model.dart';
part 'comment_reply_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CommentReplyModel {
  @JsonKey(includeIfNull: false)
  String? id;
  String? content;
  String? image;
  List<String?>? likeList;
  BaseUserModel? user;
  String? userId;
  String? createdAt;
  String? commentId;

  CommentReplyModel(
      this.id, this.content, this.image, this.likeList, this.user, this.userId, this.createdAt, this.commentId);

  factory CommentReplyModel.fromJson(Map<String, dynamic> json) => _$CommentReplyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentReplyModelToJson(this);
}