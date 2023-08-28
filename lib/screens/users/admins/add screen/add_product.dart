import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';

import 'package:hmanager/models/item_add_model.dart';
import 'package:hmanager/widgets/button.dart';
import 'package:hmanager/widgets/show_snack_bar.dart';
import 'package:hmanager/widgets/spacer.dart';
import 'package:hmanager/widgets/validator.dart';

class AddProduct extends StatelessWidget {
  AddProduct({super.key});
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Product'),
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
                      validator: validaterMandatory,
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(fontSize: 10),
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: 'Enter Product Name',
                          label: Text(
                            'Product Name',
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
    final model = ProductAddModel(
      '',
      '',
      name: proName,
    );
    final result = await CallApi.addProduct(model);
    if (result == true) {
      showSnackBar(context, '$proName Added', Colors.green.shade400);
    } else {
      showSnackBar(context, 'Error Occured', Colors.red.shade500);
    }
    nameController.clear();
    Navigator.pop(context);
  }
}
