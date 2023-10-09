// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentReplyModel _$CommentReplyModelFromJson(Map<String, dynamic> json) {
  return CommentReplyModel(
    json['id'] as String?,
    json['content'] as String?,
    json['image'] as String?,
    (json['likeList'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    json['user'] == null
        ? null
        : BaseUserModel.fromJson(json['user'] as Map<String, dynamic>),
    json['userId'] as String?,
    json['createdAt'] as String?,
    json['commentId'] as String?,
  );
}

Map<String, dynamic> _$CommentReplyModelToJson(CommentReplyModel instance) {
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
  val['commentId'] = instance.commentId;
  return val;
}
