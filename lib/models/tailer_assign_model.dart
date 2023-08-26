import 'package:json_annotation/json_annotation.dart';
part 'tailer_assign_model.g.dart';

@JsonSerializable()
class TailerAssignModel {
  final DateTime date;
  final String batchId;
  final String employ;
  final String product;
  final Object employId;
  final String empId;
  final String material;
  final Object productId;
  final Object materialId;
  final String color;
  final double assignedQuantity;
  final String status;
  final String tailerAssignID;

  TailerAssignModel(
      this.tailerAssignID, this.employ, this.product, this.material,
      {required this.assignedQuantity,
      required this.date,
      required this.batchId,
      required this.employId,
      required this.empId,
      required this.productId,
      required this.materialId,
      required this.color,
      required this.status});

  factory TailerAssignModel.fromJson(Map<String, dynamic> json) =>
      _$TailerAssignModelFromJson(json);
  Map<String, dynamic> toJson() => _$TailerAssignModelToJson(this);
}
//date: (json['date'] as Timestamp).toDate(),