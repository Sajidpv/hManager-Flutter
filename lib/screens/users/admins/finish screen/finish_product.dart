import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';

import 'package:hmanager/models/finish_model.dart';
import 'package:hmanager/models/finisher_assign_model.dart';
import 'package:hmanager/widgets/button.dart';
import 'package:hmanager/widgets/select_date.dart';
import 'package:hmanager/widgets/spacer.dart';
import 'package:hmanager/widgets/validator.dart';

import '../../../../widgets/error_visible_message.dart';

// Finish finishing
class FinisherinishItem extends StatefulWidget {
  const FinisherinishItem({
    super.key,
    required this.emp,
  });
  final FinisherAssignModel emp;

  @override
  State<FinisherinishItem> createState() => _FinisherFinishItemState();
}

class _FinisherFinishItemState extends State<FinisherinishItem> {
  final formKey = GlobalKey<FormState>();
  String formatedDate = 'Select Date';
  DateTime selectedDate = DateTime.now();
  final quantController = TextEditingController();
  final damageController = TextEditingController(text: '0');
  double availableQuantiy = 0;
  double balanceQuantity = 0;
  double? quantity;
  bool isError = false;
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
                          SizedBox(
                            width: 120,
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
                          SizedBox(
                            width: 110,
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
                                  emp.product.toString(),
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 110,
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
                                    },
                                    validator: (value) => quandityValidator(
                                        value, availableQuantiy.toString())),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
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
                                      hintText: 'Enter Damage',
                                    ),
                                    onChanged: (value) {
                                      total();
                                    },
                                    validator: (value) => damageValidator(
                                        value, quantity!, availableQuantiy)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
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
                        setState(() {
                          isError = false;
                        });
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          isError = true;
                        });
                      }
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
    quantity = double.tryParse(quantController.text) ?? 0;
    final damage = double.tryParse(damageController.text) ?? 0;
    if (quantity == null) {
      return;
    }
    setState(() {
      balanceQuantity = availableQuantiy - (quantity! + damage);
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

    final parsedDamage = double.tryParse(damage);
    if (parsedDamage == null) {
      return;
    }

    final selectedcolor = emp.color;
    final model = FinishModel(
      '',
      '',
      '',
      '',
      date: selectedDate,
      finisherAssignID: emp.finisherAssignID,
      batchId: emp.batchId,
      productId: emp.productId,
      materialId: emp.materialId,
      employId: emp.employId,
      color: selectedcolor,
      finishedQuantity: parsedQuantity,
      damage: parsedDamage,
      quantity: parsedQuantity,
    );

    CallApi.finishProduct(model);
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
