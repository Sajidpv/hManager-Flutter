import 'dart:convert';

import 'package:hmanager/db_functions/urls.dart';
import 'package:hmanager/models/color_quantity_model.dart';
import 'package:hmanager/models/colors_model.dart';
import 'package:hmanager/models/cutter_assigned_model.dart';
import 'package:hmanager/models/finish_model.dart';
import 'package:hmanager/models/finished_data_model.dart';
import 'package:hmanager/models/cutter_finishing_model.dart';
import 'package:hmanager/models/finisher_assign_model.dart';
import 'package:hmanager/models/item_add_model.dart';
import 'package:hmanager/models/product_model.dart';
import 'package:hmanager/models/stock_model.dart';
import 'package:hmanager/models/supplier_model.dart';
import 'package:hmanager/models/tailer_assign_model.dart';
import 'package:hmanager/models/tailer_finishing_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hmanager/models/employee_model.dart';
import 'package:hmanager/widgets/get_strings_types.dart';

class CallApi {
  static registerEmployee(EmployeeModel empData) async {
    var url = Uri.parse(registration);
    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(empData));

      var jsonres = await jsonDecode((res.body.toString()));
      if (jsonres['status'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<List<EmployeeModel>>? getEmployee() async {
    List<EmployeeModel> employees = [];
    var url = Uri.parse(getUsers);
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        data.forEach((value) {
          var userTypeString = value['type'];
          var userType = getUserTypeFromString(userTypeString);
          var statusString = value['status'];
          var status = getStatusFromString(statusString);
          employees.add(EmployeeModel(value['_id'],
              empID: value['empID'],
              name: value['name'],
              email: value['email'],
              type: userType,
              status: status,
              password: value['password']));
        });
        return employees;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<EmployeeModel?> getEmployeeById(id) async {
    var url = Uri.parse('$getUsersById/$id');
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        var value = jsonDecode(res.body);

        var userTypeString = value['type'];
        var userType = getUserTypeFromString(userTypeString);
        var statusString = value['status'];
        var status = getStatusFromString(statusString);

        return EmployeeModel(
          value['_id'],
          empID: value['empID'],
          name: value['name'],
          email: value['email'],
          type: userType,
          status: status,
          password: value['password'],
        );
      } else {
        return null; // Return null for no data or error
      }
    } catch (e) {
      print(e.toString());
      return null; // Return null for error
    }
  }

  static Future<List<EmployeeModel>> getFilterdUsers(UserType type) async {
    List<EmployeeModel>? allUsers = await getEmployee();
    List<EmployeeModel> filteredUsers =
        allUsers!.where((user) => user.type == type).toList();
    return filteredUsers;
  }

  static Future<bool> updateEmployeeStatus(
      String id, String status, type) async {
    final Uri url;
    if (type == 'user') {
      url = Uri.parse('$updateUStatus/$id');
    } else {
      url = Uri.parse('$updateSStatus/$id');
    }

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'status': status}),
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data.toString());
      } else {
        print(res.body.toString());
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }

    return false;
  }

  static updateEmployee(id, body) async {
    var url = Uri.parse('$updateUser/$id');

    final res = await http.patch(url, body: body);

    if (res.statusCode == 200) {
      print(jsonDecode(res.body));
    } else {
      print("Failed to update");
    }
  }

  Future<bool> deleteDocument(id, path) async {
    var url = Uri.parse(path + '/$id');
    final res = await http.delete(url);

    if (res.statusCode == 200) {
      print(jsonDecode(res.body));
      return true;
    } else {
      print("Failed to delete");
      return false;
    }
  }

//Supplier
  static registerSupplier(SupplierModel sData) async {
    var url = Uri.parse(regSupplier);
    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(sData));

      var jsonres = await jsonDecode((res.body.toString()));
      if (jsonres['status'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<List<SupplierModel>> getsupplier({Object? supplierId}) async {
    List<SupplierModel> suppliers = [];
    var url = Uri.parse(getSupllier);

    if (supplierId != null) {
      url = Uri.parse('$getSupllier/$supplierId');
    }

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        if (data is List) {
          for (var value in data) {
            var statusString = value['status'];
            var status = getStatusFromString(statusString);
            suppliers.add(SupplierModel(value['_id'],
                name: value['name'],
                address: value['address'],
                status: status));
          }
        } else if (data is Map) {
          var statusString = data['status'];
          var status = getStatusFromString(statusString);
          suppliers.add(SupplierModel(data['_id'],
              name: data['name'], address: data['address'], status: status));
        }

        return suppliers;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //Purchase
  static registerPurchase(ProductMaterialModel pData) async {
    var url = Uri.parse(purchaseAdd);
    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(pData));

      var jsonres = await jsonDecode((res.body.toString()));
      if (jsonres['status'] == true) {
        try {
          updateMaterial(materialList: pData.items);
        } catch (e) {
          print(e.toString());
        }
      } else {
        print(res.body.toString());
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Stream<List<ProductMaterialModel>> getPurchaseStream() async* {
    var url = Uri.parse(purchaseGet);
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(res.body);
        final List<dynamic> data = responseJson['data'];

        List<ProductMaterialModel> pur = data.map((value) {
          List<MaterialAddModel> items =
              (value['items'] as List<dynamic>).map((item) {
            final mat = value['mat'].firstWhere(
                (m) => m['_id'] == item['material'],
                orElse: () => null);
            final materialName = mat != null ? mat['name'] : 'No Name';

            return MaterialAddModel(
              material: materialName,
              quantity: item['quantity'].toDouble(),
              amount: item['amount'].toDouble(),
              sum: item['sum'].toDouble(),
            );
          }).toList();
          return ProductMaterialModel(
            value['_id'],
            purID: value['purID'],
            invoice: value['invoice'],
            totalAmount: value['totalAmount'].toDouble(),
            items: items,
            date: DateTime.parse(value['date']),
            description: value['description'],
            supplier: value['supplier'] != null
                ? value['supplier'][0]['name']
                : 'No Supplier',
          );
        }).toList();

        yield pur;
      } else {
        yield [];
      }
    } catch (e) {
      print(e.toString());
      yield [];
    }
  }

  //Material
  static addMaterial(StockModel mData) async {
    var url = Uri.parse(materialAdd);

    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(mData));

      var jsonres = await jsonDecode((res.body.toString()));
      if (jsonres['status'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<void> updateMaterialAdd(double quantity, Object id) async {
    http.Response res;
    try {
      var url = Uri.parse('$materialPluse/$id');

      res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'quantity': quantity}),
      );

      if (res.statusCode == 200) {
        var jsonRes = jsonDecode(res.body);
        print(jsonRes);
      } else {
        print(res.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      print(e);
    }
  }

  static Future<void> updateMaterial(
      {List<MaterialAddModel>? materialList,
      double? quantity,
      Object? id}) async {
    var res;
    try {
      if (materialList != null) {
        var url = Uri.parse(materialUpdate);
        for (var material in materialList) {
          res = await http.post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(material),
          );
        }
      } else if (quantity != null && id != null) {
        var url = Uri.parse('$materialMinus/$id');

        res = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'quantity': quantity}),
        );
      }
      if (res.statusCode == 200) {
        var jsonRes = jsonDecode(res.body);
        print(jsonRes);
      } else {
        print(res.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      print(e);
    }
  }

  Stream<List<StockModel>> getMaterialStream() async* {
    var url = Uri.parse(materialGet);

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        List<StockModel> mat = data
            .map((value) => StockModel(
                  value['_id'],
                  value['hsn'],
                  value['itemCode'],
                  name: value['name'],
                  quantity: value['quantity'],
                ))
            .toList();
        yield mat;
      } else {
        yield [];
      }
    } catch (e) {
      print(e.toString());
      yield [];
    }
  }

  static Future<List<StockModel>> getMaterial({String? stockId}) async {
    List<StockModel> mat = [];
    var url = Uri.parse(materialGet);
    if (stockId != null) {
      url = Uri.parse('$materialGet/$stockId');
    }
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        data.forEach((value) {
          mat.add(StockModel(
            value['_id'],
            value['hsn'],
            value['itemCode'],
            name: value['name'],
            quantity: value['quantity'],
          ));
        });
        return mat;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //Product
  static addProduct(ProductAddModel mData) async {
    var url = Uri.parse(productAdd);

    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(mData));

      var jsonres = await jsonDecode((res.body.toString()));
      if (jsonres['status'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Stream<List<ProductAddModel>> getProductStream() async* {
    var url = Uri.parse(productGet);

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        List<ProductAddModel> mat = data
            .map((value) => ProductAddModel(
                  value['_id'],
                  value['itemCode'],
                  name: value['name'],
                ))
            .toList();
        yield mat;
      } else {
        yield [];
      }
    } catch (e) {
      print(e.toString());
      yield [];
    }
  }

  //CuTTER assign
  static assignCutter(CutterAssignModel bData) async {
    var url = Uri.parse(cutterAssign);

    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(bData));

      var jsonres = await jsonDecode((res.body.toString()));
      if (jsonres['status'] == true) {
        try {
          updateMaterial(quantity: bData.assignedQuantity, id: bData.stockID);
        } catch (e) {
          print(e.toString());
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<CutterAssignModel>> getAssignCutter() async {
    var url = Uri.parse(assignCutterGet);

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        List<CutterAssignModel> list = data
            .map((value) => CutterAssignModel(
                  value['_id'],
                  value['product'] != null
                      ? value['product'][0]['name']
                      : 'No Product',
                  value['material'] != null
                      ? value['material'][0]['name']
                      : 'No Material',
                  value['employ'] != null
                      ? value['employ'][0]['name']
                      : 'No Employee',
                  assignedQuantity: value['assignedQuantity'].toDouble(),
                  batchID: value['batchID'],
                  productId: value['productId'],
                  stockID: value['stockID'],
                  employID: value['employID'],
                  status: value['status'],
                  empID: value['employ'][0]['empID'],
                ))
            .toList();
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // static Future<void> updateCutterStatus({double? quantity, Object? id}) async {
  //   var res;
  //   try {
  //     if (quantity != null && id != null) {
  //       var url = Uri.parse('$updateAssignCutterStatus/$id');

  //       res = await http.post(
  //         url,
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode({'status': 'Finished'}),
  //       );
  //     }
  //     if (res.statusCode == 200) {
  //       var jsonRes = jsonDecode(res.body);
  //       print(jsonRes);
  //     } else {
  //       print(res.body.toString());
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     print(e);
  //   }
  // }

  //CuTTER finish
  static finishCutter(CutterFinishingModel bData) async {
    var url = Uri.parse(cutterFinish);

    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(bData));

      var jsonres = await jsonDecode((res.body.toString()));

      if (jsonres['status'] == true) {
        try {
          updateMaterialAdd(bData.balance, bData.materialId);
          updateStatus(bData.proAssignID, 'CutterAssign');
        } catch (e) {
          print(e.toString());
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<CutterFinishingModel>> getFinishCutter() async {
    var url = Uri.parse(finishCutterGet);

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        List<CutterFinishingModel> list = data.map((value) {
          List<ColorQuantityModel> quantityList =
              (value['quantity'] as List<dynamic>).map((quantity) {
            return ColorQuantityModel(
                quantity['color'],
                quantity['quantity'].toDouble(),
                quantity['_id'],
                quantity['status']);
          }).toList();

          return CutterFinishingModel(
            value['_id'],
            value['balance'].toDouble(),
            value['damage'].toDouble(),
            value['wastage'].toDouble(),
            value['productId'][0]['name'],
            value['employId'][0]['name'],
            value['materialId'][0]['name'],
            proAssignID: value['proAssignId'][0]['_id'],
            date: DateTime.parse(value['date']),
            batchID: value['batchId'],
            productId: value['productId'][0]['_id'],
            quantity: quantityList,
            employId: value['employId'][0]['_id'],
            materialId: value['materialId'][0]['_id'],
            layerCount: value['layerCount'].toDouble(),
            meterLayer: value['meterCount'].toDouble(),
            pieceLayer: value['pieceCount'].toDouble(),
          );
        }).toList();
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<FinishedGroupModel>> fetchCutterFinishData() async {
    final url = Uri.parse(finishCutterAllGet);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      List<FinishedGroupModel> list = data.map((value) {
        List<BatchModel> batches =
            (value['batches'] as List<dynamic>).map((item) {
          List<ColorQuantityModel> colors =
              (item['colors'] as List<dynamic>).map((colorItem) {
            return ColorQuantityModel(
                colorItem['quantity']['color'],
                colorItem['quantity']['quantity'].toDouble(),
                colorItem['quantity']['_id'],
                colorItem['quantity']['status']);
          }).toList();

          MaterialModel material = MaterialModel(
            id: item['material']['_id'],
            name: item['material']['name'],
            itemCode: item['material']['itemCode'],
            hsn: item['material']['hsn'],
            quantity: item['material']['quantity'].toDouble(),
          );

          return BatchModel(
            batchId: item['batchId'],
            materialId: item['materialId'],
            colors: colors,
            material: material,
          );
        }).toList();

        List<ProductAddModel> products =
            (value['products'] as List<dynamic>).map((item) {
          return ProductAddModel(
            item['_id'],
            item['itemCode'],
            name: item['name'],
          );
        }).toList();

        return FinishedGroupModel(
          id: value['batches'][0]['colors'][0]['id'],
          batches: batches,
          products: products,
        );
      }).toList();

      return list;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //Tailer assign
  static assignTailer(TailerAssignModel bData, Object id) async {
    var url = Uri.parse(tailerAssign);

    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(bData));

      var jsonres = await jsonDecode((res.body.toString()));

      if (jsonres['status'] == true) {
        try {
          var url = Uri.parse('$updateFinishCutterStatus/$id');
          await http.post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({'color': bData.color, 'status': 'Assigned'}),
          );

          print(await jsonDecode((res.body.toString())));
        } catch (e) {
          print(e.toString());
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<TailerAssignModel>> getAssignTailer() async {
    var url = Uri.parse(assignTailerGet);

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        List<TailerAssignModel> list = data
            .map((value) => TailerAssignModel(
                value['_id'],
                value['employ'][0]['name'] ?? '',
                value['product'][0]['name'] ?? '',
                value['material'][0]['name'] ?? '',
                assignedQuantity: value['assignedQuantity'].toDouble(),
                date: DateTime.parse(value['date']),
                batchId: value['batchId'],
                employId: value['employId'],
                productId: value['productId'],
                materialId: value['materialId'],
                color: value['color'],
                status: value['status'],
                empId: value['employ'][0]['empID']))
            .toList();
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //Tailer finish
  static finishTailer(TailerFinishingModel bData) async {
    var url = Uri.parse(tailerFinish);

    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(bData));

      var jsonres = await jsonDecode((res.body.toString()));
      if (jsonres['status'] == true) {
        try {
          updateStatus(bData.tailerAssignID, 'TailerAssign');
        } catch (e) {
          print(e.toString());
        }
      } else {
        print(res.body.toString());
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  ///Status Update
  static Future<void> updateStatus(Object id, String action) async {
    var res;
    var url;
    String status = 'Assigned';
    try {
      switch (action) {
        case 'CutterAssign':
          {
            url = Uri.parse('$updateAssignCutterStatus/$id');
            status = 'Finished';
          }
        case 'TailerAssign':
          {
            url = Uri.parse('$updateAssignTailerStatus/$id');
            status = 'Finished';
          }
        case 'TailerFinish':
          {
            url = Uri.parse('$updateFinishTailerStatus/$id');
            status = 'Assigned';
          }
        case 'FinisherAssign':
          {
            url = Uri.parse('$updateAssignFinisherStatus/$id');
            status = 'Finished';
          }
      }

      res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'status': status}),
      );

      if (res.statusCode == 200) {
        var jsonRes = jsonDecode(res.body);
        print(jsonRes);
      } else {
        print(res.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      print(e);
    }
  }

  // Future<List<CutterFinishingModel>> getFinishTailer() async {
  //   var url = Uri.parse(finishCutterGet);

  //   try {
  //     final res = await http.get(url);

  //     if (res.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(res.body);
  //       List<CutterFinishingModel> list = data.map((value) {
  //         List<ColorQuantityModel> quantityList =
  //             (value['quantity'] as List<dynamic>).map((quantity) {
  //           return ColorQuantityModel(
  //             quantity['color'],
  //             quantity['quantity'].toDouble(),
  //           );
  //         }).toList();

  //         return CutterFinishingModel(
  //           value['_id'],
  //           value['balance'].toDouble(),
  //           value['damage'].toDouble(),
  //           value['wastage'].toDouble(),
  //           value['productId'][0]['name'],
  //           value['employId'][0]['name'],
  //           value['materialId'][0]['name'],
  //           proAssignID: value['proAssignId'][0]['_id'],
  //           date: DateTime.parse(value['date']),
  //           batchID: value['batchId'],
  //           productId: value['productId'][0]['_id'],
  //           quantity: quantityList,
  //           employId: value['employId'][0]['_id'],
  //           materialId: value['materialId'][0]['_id'],
  //           layerCount: value['layerCount'].toDouble(),
  //           meterLayer: value['meterCount'].toDouble(),
  //           pieceLayer: value['pieceCount'].toDouble(),
  //           usedFabrics: value['usedQuantity'].toDouble(),
  //         );
  //       }).toList();
  //       return list;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return [];
  //   }
  // }

  Future<List<FinishedGroupModel>> fetchTailerFinishData() async {
    final url = Uri.parse(finishTailerGet);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      List<FinishedGroupModel> list = data.map((value) {
        List<BatchModel> batches =
            (value['batches'] as List<dynamic>).map((item) {
          List<ColorQuantityModel> colors =
              (item['colors'] as List<dynamic>).map((colorItem) {
            return ColorQuantityModel(colorItem['color'],
                colorItem['quantity'].toDouble(), colorItem['id'], '');
          }).toList();

          MaterialModel material = MaterialModel(
            id: item['material']['_id'],
            name: item['material']['name'],
            itemCode: item['material']['itemCode'],
            hsn: item['material']['hsn'],
            quantity: item['material']['quantity'].toDouble(),
          );

          return BatchModel(
            batchId: item['batchId'],
            materialId: item['materialId'],
            colors: colors,
            material: material,
          );
        }).toList();

        List<ProductAddModel> products =
            (value['products'] as List<dynamic>).map((item) {
          return ProductAddModel(
            item['_id'],
            item['itemCode'],
            name: item['name'],
          );
        }).toList();

        return FinishedGroupModel(
          id: value['batches'][0]['colors'][0]['id'],
          batches: batches,
          products: products,
        );
      }).toList();

      return list;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //Finisher assign
  static assignFinisher(FinisherAssignModel bData) async {
    var url = Uri.parse(finisherAssign);

    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(bData));

      var jsonres = await jsonDecode((res.body.toString()));
      if (jsonres['status'] == true) {
        try {
          updateStatus(bData.tailerFinishId, 'TailerFinish');
        } catch (e) {
          print(e.toString());
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<FinisherAssignModel>> getAssignFinisher() async {
    var url = Uri.parse(assignFinisherGet);

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        List<FinisherAssignModel> list = data
            .map((value) => FinisherAssignModel(
                value['_id'],
                value['material'][0]['name'],
                value['employ'][0]['name'],
                value['product'][0]['name'],
                assignedQuantity: value['assignedQuantity'].toDouble(),
                date: DateTime.parse(value['date']),
                batchId: value['batchId'],
                employId: value['employId'],
                productId: value['productId'],
                materialId: value['materialId'],
                color: value['color'],
                tailerFinishId: value['tailerFinishId'],
                status: value['status'],
                empId: value['employ'][0]['empID']))
            .toList();
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //Finishing
  static finishProduct(FinishModel bData) async {
    var url = Uri.parse(getFinishing);
    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(bData));

      var jsonres = await jsonDecode((res.body.toString()));
      if (jsonres['status'] == true) {
        try {
          updateStatus(bData.finisherAssignID, 'FinisherAssign');
        } catch (e) {
          print(e.toString());
        }
      } else {
        print(res.body.toString());
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<void> updateFinishingQuantity(
      {double? quantity, Object? id}) async {
    var res;
    try {
      if (quantity != null && id != null) {
        var url = Uri.parse('$updateAssignTailerStatus/$id');

        res = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'quantity': quantity}),
        );
      }
      if (res.statusCode == 200) {
        var jsonRes = jsonDecode(res.body);
        print(jsonRes);
      } else {
        print(res.body.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
      print(e);
    }
  }

  // Future<List<FinishModel>> getFinishing() async {
  //   var url = Uri.parse(getFinishing);

  //   try {
  //     final res = await http.get(url);

  //     if (res.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(res.body);
  //       List<FinishModel> list = data.map((value) {
  //         List<ColorQuantityModel> quantityList =
  //             (value['quantity'] as List<dynamic>).map((quantity) {
  //           return ColorQuantityModel(
  //             quantity['color'],
  //             quantity['quantity'].toDouble(),
  //           );
  //         }).toList();

  //         return FinishModel(
  //           value['_id'],
  //           value['balance'].toDouble(),
  //           value['damage'].toDouble(),
  //           value['wastage'].toDouble(),
  //           value['productId'][0]['name'],
  //           value['employId'][0]['name'],
  //           value['materialId'][0]['name'],
  //           proAssignID: value['proAssignId'][0]['_id'],
  //           date: DateTime.parse(value['date']),
  //           batchID: value['batchId'],
  //           productId: value['productId'][0]['_id'],
  //           quantity: quantityList,
  //           employId: value['employId'][0]['_id'],
  //           materialId: value['materialId'][0]['_id'],
  //           layerCount: value['layerCount'].toDouble(),
  //           meterLayer: value['meterCount'].toDouble(),
  //           pieceLayer: value['pieceCount'].toDouble(),
  //           usedFabrics: value['usedQuantity'].toDouble(),
  //         );
  //       }).toList();
  //       return list;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return [];
  //   }
  // }

  Future<List<FinishedGroupModel>> fetchFinishedData() async {
    final url = Uri.parse(getFinishing);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      List<FinishedGroupModel> list = data.map((value) {
        List<BatchModel> batches =
            (value['batches'] as List<dynamic>).map((item) {
          List<ColorQuantityModel> colors =
              (item['colors'] as List<dynamic>).map((colorItem) {
            return ColorQuantityModel(
                colorItem['color'], colorItem['quantity'].toDouble(), '', '');
          }).toList();

          MaterialModel material = MaterialModel(
            id: item['material']['_id'],
            name: item['material']['name'],
            itemCode: item['material']['itemCode'],
            hsn: item['material']['hsn'],
            quantity: item['material']['quantity'].toDouble(),
          );

          return BatchModel(
            batchId: item['batchId'],
            materialId: item['materialId'],
            colors: colors,
            material: material,
          );
        }).toList();

        List<ProductAddModel> products =
            (value['products'] as List<dynamic>).map((item) {
          return ProductAddModel(
            item['_id'],
            item['itemCode'],
            name: item['name'],
          );
        }).toList();

        return FinishedGroupModel(
          id: value['_id']['productId'],
          batches: batches,
          products: products,
        );
      }).toList();

      return list;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //Color add
  static addColor(ColorModel bData) async {
    var url = Uri.parse(colorAdd);

    try {
      final res = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(bData));

      var jsonres = await jsonDecode((res.body.toString()));
      if (jsonres['status'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<ColorModel>> getColors() async {
    var url = Uri.parse(colorGet);

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        List<ColorModel> list = data
            .map((value) => ColorModel(value['_id'], color: value['color']))
            .toList();
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
