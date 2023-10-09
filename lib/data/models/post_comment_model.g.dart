// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCommentModel _$PostCommentModelFromJson(Map<String, dynamic> json) {
  return PostCommentModel(
    json['id'] as String?,
    json['content'] as String?,
    json['image'] as String?,
    (json['likeList'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    json['user'] == null
        ? null
        : BaseUserModel.fromJson(json['user'] as Map<String, dynamic>),
    json['userId'] as String?,
    json['createdAt'] as String?,
    json['postId'] as String?,
    json['hasReply'] as bool?,
  );
}

Map<String, dynamic> _$PostCommentModelToJson(PostCommentModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['content'] = instance.content;
  val['image'] = instance.image;
  val['likeList'] = instance.likeList;
  val['user'] = instance.user?.toJson();
  val['userId'] = instance.userId;
  val['createdAt'] = instance.createdAt;
  val['postId'] = instance.postId;
  val['hasReply'] = instance.hasReply;
  return val;
}
