import 'package:json_annotation/json_annotation.dart';
part 'item_add_model.g.dart';

@JsonSerializable()
class ProductAddModel {
  final String name;
  final String itemCode;
  final String id;

  ProductAddModel(
    this.id,
    this.itemCode, {
    required this.name,
  });
  factory ProductAddModel.fromJson(Map<String, dynamic> json) =>
      _$ProductAddModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductAddModelToJson(this);
}
