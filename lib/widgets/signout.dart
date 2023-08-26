import 'package:flutter/material.dart';
import 'package:hmanager/screens/screen_login.dart';

signOut(BuildContext context) {
  // FirebaseAuth.instance.signOut();
  pref.remove('token');
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const LoginPage()));
}
