// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cutter_assigned_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CutterAssignModel _$CutterAssignModelFromJson(Map<String, dynamic> json) =>
    CutterAssignModel(
      json['proAssignID'] as String,
      json['product'] as String,
      json['material'] as String,
      json['employ'] as String,
      assignedQuantity: (json['assignedQuantity'] as num).toDouble(),
      batchID: json['batchID'] as String,
      productId: json['productId'] as Object,
      stockID: json['stockID'] as Object,
      employID: json['employID'] as Object,
      status: json['status'] as String,
      empID: json['empID'] as String,
    );

Map<String, dynamic> _$CutterAssignModelToJson(CutterAssignModel instance) =>
    <String, dynamic>{
      'batchID': instance.batchID,
      'productId': instance.productId,
      'stockID': instance.stockID,
      'employID': instance.employID,
      'product': instance.product,
      'material': instance.material,
      'employ': instance.employ,
      'assignedQuantity': instance.assignedQuantity,
      'status': instance.status,
      'proAssignID': instance.proAssignID,
      'empID': instance.empID
    };
