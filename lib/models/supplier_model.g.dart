// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierModel _$SupplierModelFromJson(Map<String, dynamic> json) =>
    SupplierModel(
      json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      status: $enumDecode(_$StatusEnumMap, json['status']),
    );

Map<String, dynamic> _$SupplierModelToJson(SupplierModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'status': _$StatusEnumMap[instance.status]!,
      'id': instance.id,
    };

const _$StatusEnumMap = {
  Status.Active: 'Active',
  Status.Inactive: 'Inactive',
};
