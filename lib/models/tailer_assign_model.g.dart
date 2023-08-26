// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tailer_assign_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TailerAssignModel _$TailerAssignModelFromJson(Map<String, dynamic> json) =>
    TailerAssignModel(
        json['tailerAssignID'] as String,
        json['employ'] as String,
        json['product'] as String,
        json['material'] as String,
        assignedQuantity: (json['assignedQuantity'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        batchId: json['batchId'] as String,
        employId: json['employId'] as Object,
        productId: json['productId'] as Object,
        materialId: json['materialId'] as Object,
        color: json['color'] as String,
        status: json['status'] as String,
        empId: json['empId'] as String);

Map<String, dynamic> _$TailerAssignModelToJson(TailerAssignModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'batchId': instance.batchId,
      'employ': instance.employ,
      'product': instance.product,
      'employId': instance.employId,
      'material': instance.material,
      'productId': instance.productId,
      'materialId': instance.materialId,
      'color': instance.color,
      'assignedQuantity': instance.assignedQuantity,
      'status': instance.status,
      'tailerAssignID': instance.tailerAssignID,
      'empId': instance.empId
    };
