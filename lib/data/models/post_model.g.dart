// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return PostModel(
    json['id'] as String?,
    json['content'] as String?,
    (json['image'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    (json['likeList'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    json['user'] == null
        ? null
        : BaseUserModel.fromJson(json['user'] as Map<String, dynamic>),
    json['userId'] as String?,
    json['createdAt'] as String?,
    json['type'] as String?,
    json['commentCount'] as int?,
  );
}

Map<String, dynamic> _$PostModelToJson(PostModel instance) {
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
  val['type'] = instance.type;
  val['commentCount'] = instance.commentCount;
  return val;
}
