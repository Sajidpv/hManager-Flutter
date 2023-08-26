// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finished_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinishedGroupModel _$FinishedGroupModelFromJson(Map<String, dynamic> json) =>
    FinishedGroupModel(
      id: json['id'] as String,
      batches: (json['batches'] as List<dynamic>)
          .map((e) => BatchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductAddModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FinishedGroupModelToJson(FinishedGroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'batches': instance.batches,
      'products': instance.products,
    };

BatchModel _$BatchModelFromJson(Map<String, dynamic> json) => BatchModel(
      batchId: json['batchId'] as String,
      materialId: json['materialId'] as String,
      colors: (json['colors'] as List<dynamic>)
          .map((e) => ColorQuantityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      material:
          MaterialModel.fromJson(json['material'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BatchModelToJson(BatchModel instance) =>
    <String, dynamic>{
      'batchId': instance.batchId,
      'materialId': instance.materialId,
      'colors': instance.colors,
      'material': instance.material,
    };

MaterialModel _$MaterialModelFromJson(Map<String, dynamic> json) =>
    MaterialModel(
      id: json['id'] as String,
      name: json['name'] as String,
      itemCode: json['itemCode'] as String,
      hsn: json['hsn'] as String,
      quantity: (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$MaterialModelToJson(MaterialModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'itemCode': instance.itemCode,
      'hsn': instance.hsn,
      'quantity': instance.quantity,
    };
