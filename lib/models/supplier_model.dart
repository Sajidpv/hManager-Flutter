import 'package:hmanager/models/employee_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'supplier_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class SupplierModel {
  final String name;
  final String address;
  final Status status;
  String id;
  SupplierModel(this.id,
      {required this.name, required this.address, required this.status});

  factory SupplierModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierModelFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierModelToJson(this);
}
