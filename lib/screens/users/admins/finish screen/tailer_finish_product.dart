import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';

import 'package:hmanager/models/color_quantity_model.dart';
import 'package:hmanager/models/cutter_finishing_model.dart';
import 'package:hmanager/models/employee_model.dart';
import 'package:hmanager/models/tailer_assign_model.dart';
import 'package:hmanager/models/tailer_finishing_model.dart';
import 'package:hmanager/widgets/button.dart';
import 'package:hmanager/widgets/error_visible_message.dart';
import 'package:hmanager/widgets/select_date.dart';
import 'package:hmanager/widgets/show_snack_bar.dart';
import 'package:hmanager/widgets/spacer.dart';
import 'package:hmanager/widgets/validator.dart';

// tailer finishing
class TailerFinishItem extends StatefulWidget {
  const TailerFinishItem({
    super.key,
    required this.emp,
  });
  final TailerAssignModel emp;

  @override
  State<TailerFinishItem> createState() => _TailerFinishItemState();
}

class _TailerFinishItemState extends State<TailerFinishItem> {
  final formKey = GlobalKey<FormState>();
  String formatedDate = 'Select Date';
  DateTime selectedDate = DateTime.now();
  final quantController = TextEditingController();
  final damageController = TextEditingController(text: '0');
  double availableQuantiy = 0;
  double balanceQuantity = 0;
  double? quantity;
  EmployeeModel? selectedEmployee;
  bool isError = false;

  CutterFinishingModel? selectedProduct;
  ColorQuantityModel? selectedColorItem;

  @override
  void initState() {
    super.initState();
    availableQuantiy = widget.emp.assignedQuantity;
  }

  @override
  void dispose() {
    damageController.dispose();
    quantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emp = widget.emp;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(emp.product.toString()),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Employee',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  emp.employ,
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
                                  'Material',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  emp.material.toString(),
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Color',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  emp.color.toString(),
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
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
                            flex: 5,
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
                                      total();
                                      quantity =
                                          double.tryParse(quantController.text);
                                    },
                                    validator: (value) => quandityValidator(
                                        value, availableQuantiy.toString())),
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
                                  availableQuantiy.toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
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
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Damage',
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.start,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  controller: damageController,
                                  style: const TextStyle(fontSize: 10),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Damages',
                                  ),
                                  onChanged: (value) {
                                    total();
                                  },
                                  validator: (value) => damageValidator(
                                    value,
                                    quantity,
                                    availableQuantiy,
                                  ),
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
                                  balanceQuantity.toString(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                IsErrorText.buildErrorSectionVisible(isError),
                divider,
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 255, 255, 255)),
                  child: Padding(
                      padding: const EdgeInsets.all(0),
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
                      )),
                ),
                divider,
                CustomButton(
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          balanceQuantity == 0) {
                        finishItem();
                      }
                      setState(() {
                        isError = true;
                      });
                    },
                    label: 'Add to Finish')
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void total() {
    final quantity = double.tryParse(quantController.text) ?? 0;
    final damage = double.tryParse(damageController.text) ?? 0;

    setState(() {
      balanceQuantity = availableQuantiy - (quantity + damage);
    });
  }

  Future<void> finishItem() async {
    final emp = widget.emp;
    final quantity = quantController.text;
    final damage = damageController.text;

    final parsedQuantity = double.tryParse(quantity);
    if (parsedQuantity == null) {
      return;
    }
    final parseddamage = double.tryParse(damage);
    if (parseddamage == null) {
      return;
    }
    final employ = emp.employId;
    final product = emp.productId;
    final material = emp.materialId;
    final selectedcolor = emp.color;

    final model = TailerFinishingModel('', '', '', '',
        tailerAssignID: emp.tailerAssignID,
        finishedQuantity: parsedQuantity,
        damage: parseddamage,
        batchId: emp.batchId,
        date: selectedDate,
        employId: employ,
        productId: product,
        materialId: material,
        color: selectedcolor,
        status: '');
    final result = await CallApi.finishTailer(model);

    if (result == true) {
      showSnackBar(context, 'Finished Successfully', Colors.green.shade400);
    } else {
      showSnackBar(context, 'Error Occured', Colors.red.shade500);
    }
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
