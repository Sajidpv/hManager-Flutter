import 'package:json_annotation/json_annotation.dart';
part 'color_quantity_model.g.dart';

@JsonSerializable()
class ColorQuantityModel {
  final String color;
  double quantity;
  final String id;

  ColorQuantityModel(this.color, this.quantity, this.id);
  factory ColorQuantityModel.fromJson(Map<String, dynamic> json) =>
      _$ColorQuantityModelFromJson(json);
  Map<String, dynamic> toJson() => _$ColorQuantityModelToJson(this);
}
