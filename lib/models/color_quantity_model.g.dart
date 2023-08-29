// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_quantity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorQuantityModel _$ColorQuantityModelFromJson(Map<String, dynamic> json) =>
    ColorQuantityModel(
        json['color'] as String,
        (json['quantity'] as num).toDouble(),
        json['colorId'] as String,
        json['status'] as String);

Map<String, dynamic> _$ColorQuantityModelToJson(ColorQuantityModel instance) =>
    <String, dynamic>{
      'color': instance.color,
      'quantity': instance.quantity,
      'colorId': instance.colorId,
      'status': instance.status
    };
