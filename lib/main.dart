import 'package:flutter/material.dart';
import 'package:hmanager/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HManager',
        theme: ThemeData().copyWith(
          useMaterial3: false,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(3, 25, 49, 1)),
        ),
        home: const Splash());
  }
}
