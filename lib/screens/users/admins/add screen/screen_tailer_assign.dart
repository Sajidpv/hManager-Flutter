import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';

import 'package:hmanager/models/color_quantity_model.dart';
import 'package:hmanager/models/finished_data_model.dart';
import 'package:hmanager/models/employee_model.dart';
import 'package:hmanager/models/tailer_assign_model.dart';
import 'package:hmanager/widgets/button.dart';
import 'package:hmanager/widgets/shimmer_effect.dart';
import 'package:hmanager/widgets/show_snack_bar.dart';
import 'package:hmanager/widgets/spacer.dart';
import 'package:hmanager/widgets/validator.dart';

import '../../../../widgets/error_visible_message.dart';

//Asssign product to tailer
class AssignToTailer extends StatefulWidget {
  const AssignToTailer({
    super.key,
  });

  @override
  State<AssignToTailer> createState() => _AssignToTailerState();
}

class _AssignToTailerState extends State<AssignToTailer> {
  final formKey = GlobalKey<FormState>();

  final quantController = TextEditingController();
  String availableQuantiy = 'Select a Product';
  double? quantityBalance;
  String balance = 'Select Product';
  EmployeeModel? selectedEmployee;
  Future<List<EmployeeModel>>? tailers;
  Future<List<FinishedGroupModel>>? products;
  FinishedGroupModel? selectedProduct;
  ColorQuantityModel? selectedColorItem;
  BatchModel? selectedBatch;
  String material = 'Select a Product';
  String proId = '';
  bool isError = false;
  final String errorMessage = 'You should add all Pieces';
  final callApi = CallApi();
  @override
  void initState() {
    tailers = CallApi.getFilterdUsers(UserType.Tailer);
    products = callApi.fetchCutterFinishData();
    super.initState();
  }

  @override
  void dispose() {
    quantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Assign To Tailer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Employee',
                                style: TextStyle(fontSize: 12),
                              ),
                              FutureBuilder<List<EmployeeModel>>(
                                future: tailers,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      final List<EmployeeModel> cutterList =
                                          snapshot.data!;
                                      return DropdownButtonFormField<
                                          EmployeeModel>(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: const Text(
                                          'Select Employee',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        value: selectedEmployee,
                                        items: cutterList.map((emp) {
                                          return DropdownMenuItem<
                                              EmployeeModel>(
                                            value: emp,
                                            child: Text(
                                              emp.name,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (emp) {
                                          setState(() {
                                            selectedEmployee = emp;
                                          });
                                        },
                                        validator: validateDropdown,
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                  }

                                  return const ShimmerDropDown();
                                },
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Product',
                                style: TextStyle(fontSize: 12),
                              ),
                              FutureBuilder<List<FinishedGroupModel>>(
                                future: products,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      final List<FinishedGroupModel>
                                          productList = snapshot.data!;
                                      return DropdownButtonFormField<
                                          FinishedGroupModel>(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: const Text(
                                          'Select Product',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        value: selectedProduct,
                                        items: productList.map((item) {
                                          final String productName =
                                              item.products[0].name;
                                          proId = item.products[0].id;
                                          return DropdownMenuItem<
                                              FinishedGroupModel>(
                                            value: item,
                                            child: Text(
                                              productName,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (item) {
                                          setState(() {
                                            selectedProduct = item;
                                            selectedColorItem = null;
                                            material = 'Select Batch';
                                            selectedBatch = null;
                                            availableQuantiy = 'Select Batch';
                                            balance = 'Select Batch';
                                          });
                                        },
                                        validator: validateDropdown,
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                  }

                                  return const ShimmerDropDown();
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                divider,
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Batch',
                                style: TextStyle(fontSize: 12),
                              ),
                              DropdownButtonFormField<BatchModel>(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                hint: const Text(
                                  'Select Batch',
                                  style: TextStyle(fontSize: 10),
                                ),
                                value: selectedBatch,
                                items: selectedProduct?.batches.map((e) {
                                  return DropdownMenuItem<BatchModel>(
                                    value: e,
                                    child: Text(
                                      e.batchId,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (e) {
                                  setState(() {
                                    selectedBatch = e;
                                    material = e!.material.name;
                                    selectedColorItem = null;
                                    balance = 'Select Color';
                                    availableQuantiy = 'Select Color';
                                  });
                                },
                                validator: validateDropdown,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Colors',
                                style: TextStyle(fontSize: 12),
                              ),
                              DropdownButtonFormField<ColorQuantityModel>(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                hint: const Text(
                                  'Select Color',
                                  style: TextStyle(fontSize: 10),
                                ),
                                value: selectedColorItem,
                                items: selectedBatch?.colors.map((e) {
                                  return DropdownMenuItem<ColorQuantityModel>(
                                    value: e,
                                    child: Text(
                                      e.color,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (e) {
                                  setState(() {
                                    selectedColorItem = e;
                                    balance = 'Enter Quantity';

                                    availableQuantiy =
                                        selectedColorItem!.quantity.toString();
                                  });
                                },
                                validator: validateDropdown,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Material',
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                material,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                divider,
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quantity',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  controller: quantController,
                                  style: const TextStyle(fontSize: 10),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Quantity',
                                  ),
                                  onChanged: (value) {
                                    finalBalance();
                                  },
                                  validator: (value) => quandityValidator(
                                      value, availableQuantiy),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Available Pieces',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  availableQuantiy,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  balance,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
                IsErrorText.buildErrorSectionVisible(isError),
                divider,
                CustomButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() && isError == false) {
                      assignItem();
                    }
                  },
                  label: 'Assign to Tailer',
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void finalBalance() {
    final availableQuantity = double.tryParse(availableQuantiy);
    final quantity = double.tryParse(quantController.text);
    if (availableQuantity == null || quantity == null) {
      return;
    }

    setState(() {
      if (availableQuantity != quantity) {
        isError = true;
      } else {
        isError = false;
      }
    });

    final bal = availableQuantity - quantity;
    setState(() {
      balance = bal.toString();
    });
  }

  Future<void> assignItem() async {
    final quantity = quantController.text;

    final parsedQuantity = double.tryParse(quantity);

    if (parsedQuantity == null) {
      return;
    }
    final parsedAvailableQuantity = double.tryParse(availableQuantiy);

    if (parsedAvailableQuantity == null ||
        selectedProduct == null ||
        selectedEmployee == null ||
        selectedColorItem == null ||
        selectedBatch == null) {
      return;
    }

    final model = TailerAssignModel('', '', '', '',
        date: DateTime.now(),
        employId: selectedEmployee!.id,
        productId: proId,
        color: selectedColorItem!.color,
        status: '',
        batchId: selectedBatch!.batchId,
        assignedQuantity: parsedQuantity,
        materialId: selectedBatch!.materialId,
        empId: '');

    final result = await CallApi.assignTailer(model, selectedProduct!.id);
    if (result == true) {
      showSnackBar(context, 'Assigned to ${selectedEmployee!.name} Added',
          Colors.green.shade400);
    } else {
      showSnackBar(context, 'Error Occured', Colors.red.shade500);
    }
    Navigator.pop(context);
  }
}
