// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finish_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinishModel _$FinishModelFromJson(Map<String, dynamic> json) => FinishModel(
      json['finishedID'] as String,
      json['employ'] as String,
      json['product'] as String,
      json['material'] as String,
      materialId: json['materialId'] as String,
      finishedQuantity: (json['finishedQuantity'] as num).toDouble(),
      damage: (json['damage'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      finisherAssignID: json['finisherAssignID'] as String,
      batchId: json['batchId'] as String,
      employId:
          EmployeeModel.fromJson(json['employId'] as Map<String, dynamic>),
      productId: TailerFinishingModel.fromJson(
          json['productId'] as Map<String, dynamic>),
      color: json['color'] as String,
      quantity: (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$FinishModelToJson(FinishModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'batchId': instance.batchId,
      'employId': instance.employId,
      'productId': instance.productId,
      'materialId': instance.materialId,
      'product': instance.product,
      'employ': instance.employ,
      'material': instance.material,
      'color': instance.color,
      'finisherAssignID': instance.finisherAssignID,
      'finishedQuantity': instance.finishedQuantity,
      'damage': instance.damage,
      'quantity': instance.quantity,
      'finishedID': instance.finishedID,
    };
