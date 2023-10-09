import 'package:sportper/data/models/base_user_model.dart';
import 'package:sportper/data/models/post_comment_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PostModel {
  @JsonKey(includeIfNull: false)
  String? id;
  String? content;
  List<String?>? image;
  List<String?>? likeList;
  BaseUserModel? user;
  String? userId;
  String? createdAt;
  String? type;
  int? commentCount;
  @JsonKey(ignore: true)
  List<PostCommentModel?>? comments;

  PostModel(
      this.id, this.content, this.image, this.likeList, this.user, this.userId, this.createdAt, this.type, this.commentCount);

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

}