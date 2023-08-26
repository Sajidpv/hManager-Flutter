import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'cutter_assigned_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class CutterAssignModel {
  final DateTime date = DateTime.now();
  final String batchID;
  final Object productId;
  final Object stockID;
  final Object employID;
  final String product;
  final String material;
  final String employ;
  final String empID;
  final double assignedQuantity;
  final String status;
  final String proAssignID;

  CutterAssignModel(this.proAssignID, this.product, this.material, this.employ,
      {required this.assignedQuantity,
      required this.batchID,
      required this.productId,
      required this.stockID,
      required this.empID,
      required this.employID,
      required this.status});
  factory CutterAssignModel.fromJson(Map<String, dynamic> json) =>
      _$CutterAssignModelFromJson(json);
  Map<String, dynamic> toJson() => _$CutterAssignModelToJson(this);
}
