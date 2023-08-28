import 'package:flutter/material.dart';
import 'package:hmanager/screens/screen_login.dart';
import 'package:hmanager/widgets/show_snack_bar.dart';

signOut(BuildContext context, String name) {
  // FirebaseAuth.instance.signOut();
  pref.remove('token');
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const LoginPage()));
  showSnackBar(context, '$name, Logging Out..', Colors.red.shade400);
}
