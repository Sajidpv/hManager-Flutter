// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_add_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductAddModel _$ProductAddModelFromJson(Map<String, dynamic> json) =>
    ProductAddModel(
      json['id'] as String,
      json['itemCode'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProductAddModelToJson(ProductAddModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'itemCode': instance.itemCode,
      'id': instance.id,
    };
