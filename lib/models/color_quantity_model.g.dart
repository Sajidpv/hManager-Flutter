// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_quantity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColorQuantityModel _$ColorQuantityModelFromJson(Map<String, dynamic> json) =>
    ColorQuantityModel(json['color'] as String,
        (json['quantity'] as num).toDouble(), json['id'] as String);

Map<String, dynamic> _$ColorQuantityModelToJson(ColorQuantityModel instance) =>
    <String, dynamic>{
      'color': instance.color,
      'quantity': instance.quantity,
      'id': instance.id
    };
