// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cutter_finishing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CutterFinishingModel _$CutterFinishingModelFromJson(
        Map<String, dynamic> json) =>
    CutterFinishingModel(
      json['id'] as String,
      (json['balance'] as num).toDouble(),
      (json['damage'] as num).toDouble(),
      (json['wastage'] as num).toDouble(),
      json['product'] as String,
      json['employ'] as String,
      json['material'] as String,
      proAssignID: json['proAssignID'] as Object,
      date: DateTime.parse(json['date'] as String),
      batchID: json['batchID'] as String,
      productId: json['productId'] as Object,
      quantity: (json['quantity'] as List<dynamic>)
          .map((e) => ColorQuantityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      employId: json['employId'] as Object,
      materialId: json['materialId'] as Object,
      layerCount: (json['layerCount'] as num).toDouble(),
      meterLayer: (json['meterLayer'] as num).toDouble(),
      pieceLayer: (json['pieceLayer'] as num).toDouble(),
    );

Map<String, dynamic> _$CutterFinishingModelToJson(
        CutterFinishingModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'proAssignID': instance.proAssignID,
      'batchID': instance.batchID,
      'product': instance.product,
      'employ': instance.employ,
      'material': instance.material,
      'productId': instance.productId,
      'employId': instance.employId,
      'materialId': instance.materialId,
      'layerCount': instance.layerCount,
      'meterLayer': instance.meterLayer,
      'pieceLayer': instance.pieceLayer,
      'quantity': instance.quantity,
      'balance': instance.balance,
      'damage': instance.damage,
      'wastage': instance.wastage,
      'id': instance.id,
    };
