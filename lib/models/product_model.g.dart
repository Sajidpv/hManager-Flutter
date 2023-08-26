// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductMaterialModel _$ProductMaterialModelFromJson(
        Map<String, dynamic> json) =>
    ProductMaterialModel(
      json['id'] as String,
      purID: json['purID'] as String,
      invoice: json['invoice'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((e) => MaterialAddModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      supplier: json['supplier'] as Object,
    );

Map<String, dynamic> _$ProductMaterialModelToJson(
        ProductMaterialModel instance) =>
    <String, dynamic>{
      'purID': instance.purID,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'supplier': instance.supplier,
      'invoice': instance.invoice,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'id': instance.id,
    };

MaterialAddModel _$MaterialAddModelFromJson(Map<String, dynamic> json) =>
    MaterialAddModel(
      material: json['material'] as Object,
      quantity: (json['quantity'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      sum: (json['sum'] as num).toDouble(),
    )..proID = json['proID'] as String;

Map<String, dynamic> _$MaterialAddModelToJson(MaterialAddModel instance) =>
    <String, dynamic>{
      'material': instance.material,
      'quantity': instance.quantity,
      'amount': instance.amount,
      'sum': instance.sum,
      'proID': instance.proID,
    };
