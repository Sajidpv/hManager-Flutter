import 'package:json_annotation/json_annotation.dart';
part 'finisher_assign_model.g.dart';

@JsonSerializable()
class FinisherAssignModel {
  final DateTime date;
  final String batchId;
  final String material;
  final String employ;
  final String product;
  final Object employId;
  final String empId;
  final Object productId;
  final Object materialId;
  final String color;
  final double assignedQuantity;
  final Object tailerFinishId;
  final String finisherAssignID;
  final String status;

  FinisherAssignModel(
      this.finisherAssignID, this.material, this.employ, this.product,
      {required this.assignedQuantity,
      required this.date,
      required this.batchId,
      required this.materialId,
      required this.employId,
      required this.empId,
      required this.productId,
      required this.color,
      required this.tailerFinishId,
      required this.status});
  factory FinisherAssignModel.fromJson(Map<String, dynamic> json) =>
      _$FinisherAssignModelFromJson(json);
  Map<String, dynamic> toJson() => _$FinisherAssignModelToJson(this);
}
//   date: (json['date'] as Timestamp).toDate(),