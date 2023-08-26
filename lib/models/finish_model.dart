import 'package:hmanager/models/employee_model.dart';
import 'package:hmanager/models/tailer_finishing_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'finish_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class FinishModel {
  final DateTime date;
  final String batchId;
  final String employ;
  final String product;
  final String material;
  final Object employId;
  final Object productId;
  final Object materialId;
  final String color;
  final String finisherAssignID;
  final double finishedQuantity;
  final double damage;
  double quantity;
  final String finishedID;

  FinishModel(this.finishedID, this.employ, this.product, this.material,
      {required this.finishedQuantity,
      required this.damage,
      required this.date,
      required this.finisherAssignID,
      required this.batchId,
      required this.employId,
      required this.productId,
      required this.materialId,
      required this.color,
      required this.quantity});
  factory FinishModel.fromJson(Map<String, dynamic> json) =>
      _$FinishModelFromJson(json);
  Map<String, dynamic> toJson() => _$FinishModelToJson(this);
}
//   date: (json['date'] as Timestamp).toDate(),