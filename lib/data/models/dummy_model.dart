import 'package:json_annotation/json_annotation.dart';

part 'dummy_model.g.dart';
@JsonSerializable()
class DummyModel {
  @JsonKey(defaultValue: "")
  String dummy;

  DummyModel(this.dummy);

  static const fromJsonFactory = _$DummyModelFromJson;
  factory DummyModel.fromJson(json) => _$DummyModelFromJson(json);
}
