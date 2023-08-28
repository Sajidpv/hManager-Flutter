import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';

import 'package:hmanager/models/stock_model.dart';
import 'package:hmanager/widgets/button.dart';
import 'package:hmanager/widgets/show_snack_bar.dart';

import 'package:hmanager/widgets/spacer.dart';
import 'package:hmanager/widgets/validator.dart';

class AddMaterial extends StatelessWidget {
  AddMaterial({super.key});
  final nameController = TextEditingController();
  final hsnController = TextEditingController();
  final openingBalanceController = TextEditingController(text: '0');
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Material'),
      ),
      backgroundColor: Colors.grey.shade300,
      body: Padding(
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
                    padding: const EdgeInsets.all(0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: validaterMandatory,
                      controller: nameController,
                      style: const TextStyle(fontSize: 10),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: 'Enter Material Name',
                          label: Text(
                            'Material Name',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          )),
                    )),
              ),
              divider,
              // Container(
              //   decoration: const BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(20)),
              //       color: Color.fromARGB(255, 255, 255, 255)),
              //   child: Padding(
              //       padding: const EdgeInsets.all(0),
              //       child: TextFormField(
              //         textInputAction: TextInputAction.next,
              //         validator: validaterMCode,
              //         controller: itemCodeController,
              //         style: const TextStyle(fontSize: 10),
              //         decoration: const InputDecoration(
              //             border: OutlineInputBorder(
              //                 borderRadius:
              //                     BorderRadius.all(Radius.circular(20))),
              //             hintText: 'Enter Material Code',
              //             label: Text(
              //               'Item Code',
              //               style: TextStyle(fontSize: 15, color: Colors.black),
              //             )),
              //       )),
              // ),
              // divider,
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromARGB(255, 255, 255, 255)),
                child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: TextFormField(
                      controller: hsnController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 10),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: 'Enter HSN Number',
                          label: Text(
                            'HSN',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          )),
                    )),
              ),
              divider,
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color.fromARGB(255, 255, 255, 255)),
                child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: TextFormField(
                      validator: validaterMandatory,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      controller: openingBalanceController,
                      style: const TextStyle(fontSize: 10),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: 'Enter Opening Balance',
                          label: Text(
                            'Opening Balance',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          )),
                    )),
              ),
              divider,
              CustomButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    addNewItem(context);
                  }
                },
                label: 'Add',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addNewItem(context) async {
    final proName = nameController.text;
    final hsn = hsnController.text;
    final balance = double.tryParse(openingBalanceController.text);

    if (balance == null) {
      return;
    }
    final model = StockModel('', hsn, '', name: proName, quantity: balance);

    final result = await CallApi.addMaterial(model);
    if (result == true) {
      showSnackBar(context, '$proName Added', Colors.green.shade400);
    } else {
      showSnackBar(context, 'Error Occured', Colors.red.shade500);
    }
    Navigator.pop(context);
  }
}
