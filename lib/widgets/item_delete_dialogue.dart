import 'package:flutter/material.dart';
import 'package:hmanager/Services/api.dart';
import 'package:hmanager/db_functions/urls.dart';
import 'package:hmanager/models/employee_model.dart';
import 'package:hmanager/models/supplier_model.dart';

void showDeleteConfirmationDialog(
    BuildContext context, dynamic item, VoidCallback onDelete) {
  String collectionUrl;
  String idFieldName;
  final callApi = CallApi();
  if (item is SupplierModel) {
    collectionUrl = deleteSupplier;
    idFieldName = item.id;
  } else if (item is EmployeeModel) {
    collectionUrl = deleteUser;
    idFieldName = item.id;
  } else {
    return;
  }

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${item.name}?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final isDeleted =
                  await callApi.deleteDocument(idFieldName, collectionUrl);

              if (isDeleted == true) {
                onDelete();
              }
            },
          ),
        ],
      );
    },
  );
}
