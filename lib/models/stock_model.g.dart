// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockModel _$StockModelFromJson(Map<String, dynamic> json) => StockModel(
      json['id'] as String,
      json['hsn'] as String?,
      json['itemCode'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as num,
    );

Map<String, dynamic> _$StockModelToJson(StockModel instance) =>
    <String, dynamic>{
      'itemCode': instance.itemCode,
      'name': instance.name,
      'hsn': instance.hsn,
      'quantity': instance.quantity,
      'id': instance.id,
    };
