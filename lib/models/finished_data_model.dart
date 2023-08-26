import 'package:hmanager/models/color_quantity_model.dart';
import 'package:hmanager/models/item_add_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'finished_data_model.g.dart';

@JsonSerializable()
class FinishedGroupModel {
  final String id;
  final List<BatchModel> batches;
  final List<ProductAddModel> products;

  FinishedGroupModel({
    required this.id,
    required this.batches,
    required this.products,
  });

  factory FinishedGroupModel.fromJson(Map<String, dynamic> json) =>
      _$FinishedGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$FinishedGroupModelToJson(this);
}

@JsonSerializable()
class BatchModel {
  final String batchId;
  final String materialId;
  final List<ColorQuantityModel> colors;
  final MaterialModel material;

  BatchModel({
    required this.batchId,
    required this.materialId,
    required this.colors,
    required this.material,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) =>
      _$BatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$BatchModelToJson(this);
}

@JsonSerializable()
class MaterialModel {
  final String id;
  final String name;
  final String itemCode;
  final String hsn;
  final double quantity;

  MaterialModel({
    required this.id,
    required this.name,
    required this.itemCode,
    required this.hsn,
    required this.quantity,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) =>
      _$MaterialModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialModelToJson(this);
}
