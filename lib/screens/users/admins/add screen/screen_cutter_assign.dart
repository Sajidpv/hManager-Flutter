import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';

import 'package:hmanager/models/employee_model.dart';
import 'package:hmanager/models/cutter_assigned_model.dart';
import 'package:hmanager/models/item_add_model.dart';
import 'package:hmanager/models/stock_model.dart';
import 'package:hmanager/screens/splash_screen.dart';
import 'package:hmanager/screens/users/admins/add%20screen/add_product.dart';
import 'package:hmanager/widgets/button.dart';
import 'package:hmanager/widgets/shimmer_effect.dart';
import 'package:hmanager/widgets/show_snack_bar.dart';
import 'package:hmanager/widgets/spacer.dart';
import 'package:hmanager/widgets/validator.dart';

//Asssign product to cutter
class AssignItems extends StatefulWidget {
  const AssignItems({
    super.key,
  });

  @override
  State<AssignItems> createState() => _AssignItemsState();
}

class _AssignItemsState extends State<AssignItems> {
  final formKey = GlobalKey<FormState>();
  final quantController = TextEditingController();
  String availableQuantiy = 'Select a material';
  UserType? type;
  double? quantityBalance;
  String? productId;

  EmployeeModel? selectedEmployee;
  String balance = '0';
  String title = '';
  late ValueNotifier listener;
  ProductAddModel? selectedProduct;
  StockModel? selectedMaterial;
  Stream<List<ProductAddModel>>? products;
  Future<List<StockModel>>? material;
  Future<List<EmployeeModel>>? cutters;
  final callapi = CallApi();
  @override
  void initState() {
    products = callapi.getProductStream();
    material = CallApi.getMaterial();
    cutters = CallApi.getFilterdUsers(UserType.Cutter);
    super.initState();
  }

  @override
  void dispose() {
    quantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    title = 'Assign to cutter';
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => pageNavigator(AddProduct(), context),
            icon: const Icon(Icons.add_outlined),
            tooltip: 'Add new product',
          )
        ],
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
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Product',
                                style: TextStyle(fontSize: 12),
                              ),
                              StreamBuilder<List<ProductAddModel>>(
                                stream: products,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    final List<ProductAddModel> productList =
                                        snapshot.data!;
                                    return DropdownButtonFormField<
                                        ProductAddModel>(
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      hint: const Text(
                                        'Select Product',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      value: selectedProduct,
                                      items: productList.map((item) {
                                        return DropdownMenuItem<
                                            ProductAddModel>(
                                          value: item,
                                          child: Text(
                                            item.name,
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (item) {
                                        setState(() {
                                          selectedProduct = item;
                                        });
                                      },
                                      validator: validateDropdown,
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  return const ShimmerDropDown();
                                },
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
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
                                future: cutters,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      final List<EmployeeModel> cutterList =
                                          snapshot.data!;
                                      final List<EmployeeModel>
                                          activeCutterList = cutterList
                                              .where((emp) =>
                                                  emp.status == Status.Active)
                                              .toList();
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
                                        items: activeCutterList.map((emp) {
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
                        )
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Material',
                                style: TextStyle(fontSize: 12),
                              ),
                              FutureBuilder<List<StockModel>>(
                                future: material,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      final List<StockModel> stockList =
                                          snapshot.data!
                                              .where(
                                                  (item) => item.quantity != 0)
                                              .toList();

                                      return DropdownButtonFormField<
                                          StockModel>(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: const Text(
                                          'Select material',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        value: selectedMaterial,
                                        items: stockList.map((item) {
                                          return DropdownMenuItem<StockModel>(
                                            value: item,
                                            child: Text(
                                              item.name,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (item) {
                                          setState(() {
                                            selectedMaterial = item;
                                            selectedMaterial!.quantity == 0
                                                ? availableQuantiy = 'No stock'
                                                : availableQuantiy =
                                                    selectedMaterial!.quantity
                                                        .toString();
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
                        width15,
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
                                height: 25,
                              ),
                              Text(
                                availableQuantiy,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
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
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
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
                                  'Balance',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 25,
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
                divider,
                CustomButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      assignItem();
                    }
                  },
                  label: 'Assign to cutter',
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
    });
  }

  Future<void> assignItem() async {
    formKey.currentState!.save();
    final quantity = quantController.text;
    final parsedQuantity = double.tryParse(quantity);

    final parsedAvailableQuantity = double.tryParse(availableQuantiy);

    if (parsedAvailableQuantity == null ||
        selectedEmployee == null ||
        selectedMaterial == null ||
        selectedProduct == null ||
        parsedQuantity == null) {
      return;
    }

    final model = CutterAssignModel('', '', '', '',
        stockID: selectedMaterial!.id,
        employID: selectedEmployee!.id,
        status: '',
        batchID: '',
        productId: selectedProduct!.id,
        assignedQuantity: parsedQuantity,
        empID: '');
    final result = await CallApi.assignCutter(model);
    if (result == true) {
      showSnackBar(context, 'Assigned to ${selectedEmployee!.name} Added',
          Colors.green.shade400);
    } else {
      showSnackBar(context, 'Error Occured', Colors.red.shade500);
    }
    Navigator.pop(context);
  }
}
