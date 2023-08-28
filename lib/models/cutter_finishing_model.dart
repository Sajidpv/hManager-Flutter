import 'package:hmanager/models/color_quantity_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'cutter_finishing_model.g.dart';

var uuid = const Uuid();

@JsonSerializable()
class CutterFinishingModel {
  final DateTime date;
  final Object proAssignID;
  final String batchID;
  final String product;
  final String employ;
  final String material;
  final Object productId;
  final Object employId;
  final Object materialId;
  final double layerCount;
  final double meterLayer;
  final double pieceLayer;
  List<ColorQuantityModel> quantity;
  double balance;
  double damage;
  double wastage;
  final String status;
  String id;
//date: (json['date'] as Timestamp).toDate(),
  CutterFinishingModel(this.id, this.balance, this.damage, this.wastage,
      this.product, this.employ, this.material,
      {required this.proAssignID,
      required this.date,
      required this.batchID,
      required this.productId,
      required this.quantity,
      required this.employId,
      required this.materialId,
      required this.layerCount,
      required this.meterLayer,
      required this.pieceLayer,
      required this.status});

  factory CutterFinishingModel.fromJson(Map<String, dynamic> json) =>
      _$CutterFinishingModelFromJson(json);
  Map<String, dynamic> toJson() => _$CutterFinishingModelToJson(this);

  @override
  String toString() {
    return 'CutterFinishingModel{'
        'date: $date, '
        'proAssignID: $proAssignID, '
        'batchID: $batchID, '
        'productId: $productId, '
        'materialId: $materialId, '
        'employId: $employId, '
        'layerCount: $layerCount, '
        'meterLayer: $meterLayer, '
        'pieceLayer: $pieceLayer, '
        'quantity: $quantity, '
        'balanceQuantity: $balance, '
        'damageQuantity: $damage, '
        'wasteQuantity: $wastage, '
        'status: $status'
        '}';
  }
}
//  'date': Timestamp.fromDate(instance.date),date: timestamp.toDate(),