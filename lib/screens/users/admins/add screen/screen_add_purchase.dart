import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';

import 'package:hmanager/models/product_model.dart';
import 'package:hmanager/models/stock_model.dart';
import 'package:hmanager/models/supplier_model.dart';
import 'package:hmanager/screens/splash_screen.dart';
import 'package:hmanager/screens/users/admins/add%20screen/add_material_to_stock.dart';
import 'package:hmanager/screens/users/admins/add%20screen/screen_add_supplier.dart';
import 'package:hmanager/widgets/button.dart';
import 'package:hmanager/widgets/select_date.dart';
import 'package:hmanager/widgets/shimmer_effect.dart';
import 'package:hmanager/widgets/spacer.dart';
import 'package:hmanager/widgets/validator.dart';

//Add Product material
class AddPurchase extends StatefulWidget {
  const AddPurchase({super.key});

  @override
  State<AddPurchase> createState() => _AddPurchaseState();
}

class _AddPurchaseState extends State<AddPurchase> {
  Future<List<StockModel>>? material;
  Future<List<SupplierModel>>? supplier;
  final formKey = GlobalKey<FormState>();
  final itemFormKey = GlobalKey<FormState>();
  String formatedDate = 'Select Date';
  DateTime selectedDate = DateTime.now();
  bool isVisible = false;
  final discriptionController = TextEditingController();
  List<MaterialAddModel> items = [];
  List<StockModel> stockItems = [];
  final quantController = TextEditingController();
  double totalAmount = 0;
  final amountController = TextEditingController();
  final invoiceController = TextEditingController(text: '');
  late double sum = 0;
  SupplierModel? selectedSupplier;
  bool visible = false;
  StockModel? selectedMaterial;
  @override
  void initState() {
    material = CallApi.getMaterial();
    supplier = CallApi.getsupplier();
    super.initState();
  }

  @override
  void dispose() {
    invoiceController.dispose();
    discriptionController.dispose();
    quantController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Add Purchase'),
        actions: [
          IconButton(
            onPressed: () => pageNavigator(AddMaterial(), context),
            icon: const Icon(Icons.add_outlined),
            tooltip: 'Add new product material',
          ),
          IconButton(
            onPressed: () => pageNavigator(const AddSupplier(), context),
            icon: const Icon(Icons.person_add),
            tooltip: 'Add new Supplier',
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
                divider,
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Column(
                    children: [
                      TextButton.icon(
                        onPressed: () => _selectDate(context),
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          formatedDate.toString(),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black),
                        ),
                      ),
                    ],
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
                            children: [
                              const Text(
                                'Supplier',
                                style: TextStyle(fontSize: 12),
                              ),
                              FutureBuilder<List<SupplierModel>>(
                                future: supplier,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      final List<SupplierModel> supplierList =
                                          snapshot.data!;
                                      return DropdownButtonFormField<
                                          SupplierModel>(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        hint: const Text(
                                          'Select supplier',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        value: selectedSupplier,
                                        items: supplierList.map((item) {
                                          return DropdownMenuItem<
                                              SupplierModel>(
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
                                            selectedSupplier = item;
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
                                'Supplier Invoice',
                                style: TextStyle(fontSize: 12),
                              ),
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: invoiceController,
                                style: const TextStyle(fontSize: 10),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Supplier Invoice',
                                ),
                                onChanged: (value) {
                                  total();
                                },
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Decription',
                          style: TextStyle(fontSize: 12),
                        ),
                        TextFormField(
                            maxLength: 30,
                            maxLines: 4,
                            controller: discriptionController,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(fontSize: 10),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Material description',
                            ),
                            validator: validaterMandatory),
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
                      child: Form(
                        key: itemFormKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  const Text(
                                    'Material',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  FutureBuilder(
                                    future: material,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasData) {
                                          final List<StockModel> stockList =
                                              snapshot.data!;
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
                                            items: stockList.map((stockItem) {
                                              return DropdownMenuItem<
                                                  StockModel>(
                                                value: stockItem,
                                                child: Text(
                                                  stockItem.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (stockItem) {
                                              setState(() {
                                                selectedMaterial = stockItem;
                                              });
                                            },
                                            validator: validateDropdown,
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
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
                              flex: 2,
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
                                      total();
                                    },
                                    validator: validaterMandatory,
                                  ),
                                ],
                              ),
                            ),
                            width15,
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Amount',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    controller: amountController,
                                    style: const TextStyle(fontSize: 10),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter amount',
                                    ),
                                    onChanged: (value) {
                                      total();
                                    },
                                    validator: validaterMandatory,
                                  ),
                                ],
                              ),
                            ),
                            width15,
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    sum.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                divider,
                TextButton.icon(
                  style: ButtonStyle(
                    side: MaterialStateProperty.resolveWith<BorderSide>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return const BorderSide(
                              color: Colors.red, width: 4.0);
                        }
                        return const BorderSide(
                            color: Colors.black, width: 1.0);
                      },
                    ),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {
                    if (itemFormKey.currentState!.validate()) {
                      addQuantity();
                      visible = false;
                      isVisible = true;
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                ),
                divider,
                Visibility(
                  visible: isVisible,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color.fromARGB(255, 255, 255, 255)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Entered Quantity',
                                style: TextStyle(fontSize: 12),
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      items.clear();
                                      isVisible = false;
                                      totalAmount = 0;
                                      sum = 0;
                                    });
                                  },
                                  child: const Text("Clear List"))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 300,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 8,
                                              child: Text(
                                                items[index]
                                                    .material
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                '${items[index].quantity.toString()}*${items[index].amount.toString()}',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                '=${items[index].sum}',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Total: ${totalAmount.toString()}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: visible,
                    child: const Center(
                        child: Text(
                      'Add atleast one item to submit',
                      style: TextStyle(color: Colors.red),
                    ))),
                divider,
                CustomButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (items.isNotEmpty) {
                        visible = false;
                        addProduct();
                      } else {
                        setState(() {
                          visible = true;
                        });
                      }
                    }
                  },
                  label: 'Add to Purchase',
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void addQuantity() {
    final quantity = quantController.text;
    final amount = amountController.text;

    final parsedQuantity = double.tryParse(quantity);

    if (selectedMaterial == null) {
      return;
    }
    if (parsedQuantity == null) {
      return;
    }
    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null) {
      return;
    }

    setState(() {
      items.add(MaterialAddModel(
          material: selectedMaterial!.id,
          quantity: parsedQuantity,
          amount: parsedAmount,
          sum: sum));
      quantController.clear();
      amountController.clear();
      selectedMaterial = null;
      totalAmount += sum;
      sum = 0;
    });
  }

  void total() {
    final parsedQuantity = double.tryParse(quantController.text);
    final parsedAmount = double.tryParse(amountController.text);
    if (parsedAmount == null || parsedQuantity == null) {
      return;
    }
    setState(() {
      sum = parsedAmount * parsedQuantity;
    });
  }

  Future<void> addProduct() async {
    formKey.currentState!.save();
    final prodesc = discriptionController.text;
    final invoice = invoiceController.text;

    final model = ProductMaterialModel('',
        totalAmount: totalAmount,
        items: items,
        date: selectedDate,
        description: prodesc,
        supplier: selectedSupplier!.id,
        invoice: invoice,
        purID: '');
    CallApi.registerPurchase(model);
    discriptionController.clear();
    invoiceController.clear();
    setState(() {
      isVisible = false;
      totalAmount = 0;
    });
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await selectDate(context);

    if (pickedDate != null) {
      setState(() {
        formatedDate = formatDate(pickedDate);
        selectedDate = pickedDate;
      });
    }
  }
}
