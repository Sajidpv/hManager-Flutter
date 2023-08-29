import 'package:json_annotation/json_annotation.dart';
part 'color_quantity_model.g.dart';

@JsonSerializable()
class ColorQuantityModel {
  final String color;
  final double quantity;
  final String colorId;
  final String status;

  ColorQuantityModel(this.color, this.quantity, this.colorId, this.status);
  factory ColorQuantityModel.fromJson(Map<String, dynamic> json) =>
      _$ColorQuantityModelFromJson(json);
  Map<String, dynamic> toJson() => _$ColorQuantityModelToJson(this);
}
