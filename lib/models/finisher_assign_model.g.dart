// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finisher_assign_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinisherAssignModel _$FinisherAssignModelFromJson(Map<String, dynamic> json) =>
    FinisherAssignModel(json['material'] as String, json['employ'] as String,
        json['product'] as String, json['finisherAssignID'] as String,
        assignedQuantity: (json['assignedQuantity'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        batchId: json['batchId'] as String,
        materialId: json['materialId'] as Object,
        employId: json['employId'] as Object,
        productId: json['productId'] as Object,
        color: json['color'] as String,
        tailerFinishId: json['tailerFinishId'] as Object,
        status: json['status'] as String,
        empId: json['empId'] as String);

Map<String, dynamic> _$FinisherAssignModelToJson(
        FinisherAssignModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'batchId': instance.batchId,
      'material': instance.material,
      'employ': instance.employ,
      'product': instance.product,
      'employId': instance.employId,
      'empId': instance.empId,
      'productId': instance.productId,
      'materialId': instance.materialId,
      'color': instance.color,
      'assignedQuantity': instance.assignedQuantity,
      'tailerFinishId': instance.tailerFinishId,
      'finisherAssignID': instance.finisherAssignID,
      'status': instance.status
    };
