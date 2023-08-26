import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'tailer_finishing_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class TailerFinishingModel {
  final DateTime date;
  final Object tailerAssignID;
  final String batchId;
  final String employ;
  final String product;
  final String material;
  final Object employId;
  final Object productId;
  final Object materialId;
  final String color;
  final double finishedQuantity;
  final double damage;
  final String status;
  final String tailerFinishID;

  TailerFinishingModel(
      this.tailerFinishID, this.employ, this.product, this.material,
      {required this.tailerAssignID,
      required this.finishedQuantity,
      required this.damage,
      required this.batchId,
      required this.date,
      required this.employId,
      required this.productId,
      required this.materialId,
      required this.color,
      required this.status});

  factory TailerFinishingModel.fromJson(Map<String, dynamic> json) =>
      _$TailerFinishingModelFromJson(json);
  Map<String, dynamic> toJson() => _$TailerFinishingModelToJson(this);
}
//   date: (json['date'] as Timestamp).toDate(),