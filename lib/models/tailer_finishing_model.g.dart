// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tailer_finishing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TailerFinishingModel _$TailerFinishingModelFromJson(
        Map<String, dynamic> json) =>
    TailerFinishingModel(
      json['tailerFinishID'] as String,
      json['employ'] as String,
      json['product'] as String,
      json['material'] as String,
      tailerAssignID: json['tailerAssignID'] as Object,
      finishedQuantity: (json['finishedQuantity'] as num).toDouble(),
      damage: (json['damage'] as num).toDouble(),
      batchId: json['batchId'] as String,
      date: DateTime.parse(json['date'] as String),
      employId: json['employId'] as Object,
      productId: json['productId'] as Object,
      materialId: json['materialId'] as Object,
      color: json['color'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$TailerFinishingModelToJson(
        TailerFinishingModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'tailerAssignID': instance.tailerAssignID,
      'batchId': instance.batchId,
      'employ': instance.employ,
      'product': instance.product,
      'material': instance.material,
      'employId': instance.employId,
      'productId': instance.productId,
      'materialId': instance.materialId,
      'color': instance.color,
      'finishedQuantity': instance.finishedQuantity,
      'damage': instance.damage,
      'status': instance.status,
      'tailerFinishID': instance.tailerFinishID,
    };
