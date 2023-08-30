import 'package:flutter/material.dart';
import 'package:hmanager/screens/screen_login.dart';
import 'package:hmanager/widgets/show_snack_bar.dart';

Future<void> signOut(BuildContext context, String name) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Logout Confirmation',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Are you sure you want to log out?',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Logout'),
            onPressed: () {
              Navigator.of(context).pop();
              pref.remove('token');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
              showSnackBar(
                  context, '$name, Logging Out..', Colors.red.shade400);
            },
          ),
        ],
      );
    },
  );
}
