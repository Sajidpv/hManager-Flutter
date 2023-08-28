import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}
