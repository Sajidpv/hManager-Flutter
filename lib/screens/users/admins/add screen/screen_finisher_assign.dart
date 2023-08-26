import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';

import 'package:hmanager/models/color_quantity_model.dart';
import 'package:hmanager/models/finished_data_model.dart';
import 'package:hmanager/models/employee_model.dart';
import 'package:hmanager/models/finisher_assign_model.dart';
import 'package:hmanager/widgets/button.dart';
import 'package:hmanager/widgets/error_visible_message.dart';
import 'package:hmanager/widgets/shimmer_effect.dart';
import 'package:hmanager/widgets/spacer.dart';
import 'package:hmanager/widgets/validator.dart';

//Asssign product to Finisher
class AssignToFinisher extends StatefulWidget {
  const AssignToFinisher({
    super.key,
  });

  @override
  State<AssignToFinisher> createState() => _AssignToFinisherState();
}

class _AssignToFinisherState extends State<AssignToFinisher> {
  final formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  final quantController = TextEditingController();
  String availableQuantiy = 'Select a Product';
  String balance = 'Enter Quantity';
  String material = 'Select Product';
  double? quantityBalance;
  ColorQuantityModel? selectedColorItem;
  EmployeeModel? selectedEmployee;
  Future<List<EmployeeModel>>? finishers;
  Future<List<FinishedGroupModel>>? products;
  FinishedGroupModel? selectedProduct;
  BatchModel? selectedBatch;
  String proId = '';
  bool isError = false;
  final callApi = CallApi();
  @override
  void initState() {
    super.initState();
    finishers = CallApi.getFilterdUsers(UserType.Finisher);
    products = callApi.fetchTailerFinishData();
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
        title: const Text('Assign To Finisher'),
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
                                future: finishers,
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
                          flex: 3,
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
                                          proId = item.products[0].id;
                                          return DropdownMenuItem<
                                              FinishedGroupModel>(
                                            value: item,
                                            child: Text(
                                              item.products[0].name,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (item) {
                                          setState(() {
                                            selectedProduct = item;
                                            selectedColorItem = null;
                                            selectedBatch = null;
                                            availableQuantiy = 'select Color';
                                            material = 'Select Batch';
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
                                  'Item Batch',
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
                                      selectedColorItem = null;
                                      material = e!.material.name;
                                      balance = 'Select Color';
                                      availableQuantiy = 'Select Color';
                                    });
                                  },
                                  validator: validateDropdown,
                                ),
                              ],
                            )),
                        const SizedBox(
                          width: 40,
                        ),
                        Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Item Color',
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

                                      availableQuantiy = selectedColorItem!
                                          .quantity
                                          .toString();
                                    });
                                  },
                                  validator: validateDropdown,
                                ),
                              ],
                            )),
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
                            )),
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
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
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
                                  'Available Quantity',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  availableQuantiy,
                                  style: const TextStyle(fontSize: 12),
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
                      // Navigator.pop(context);
                    }
                  },
                  label: 'Assign to Finisher',
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
    final bal = availableQuantity - quantity;
    setState(() {
      balance = bal.toString();
      if (availableQuantity != quantity) {
        isError = true;
      } else {
        isError = false;
      }
    });
  }

  Future<void> assignItem() async {
    final parsedQuantity = double.tryParse(quantController.text);

    if (parsedQuantity == null) {
      return;
    }
    final parsedAvailableQuantity = double.tryParse(availableQuantiy);

    if (parsedAvailableQuantity == null) {
      return;
    }

    final model = FinisherAssignModel('', '', '', '',
        date: selectedDate,
        batchId: selectedBatch!.batchId,
        color: selectedColorItem!.color,
        tailerFinishId: selectedColorItem!.id,
        assignedQuantity: parsedQuantity,
        materialId: selectedBatch!.material.id,
        employId: selectedEmployee!.id,
        productId: proId,
        status: '',
        empId: '');
    CallApi.assignFinisher(model);
    Navigator.pop(context);
  }
}
