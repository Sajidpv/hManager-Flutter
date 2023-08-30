import 'package:flutter/material.dart';
import 'package:hmanager/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? _lastBackPressedTime;

  Future<bool> _onBackPressed() async {
    final currentTime = DateTime.now();

    if (_lastBackPressedTime == null ||
        currentTime.difference(_lastBackPressedTime!) > Duration(seconds: 2)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Press again to exit')),
      );
      _lastBackPressedTime = currentTime;
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HManager',
          theme: ThemeData().copyWith(
            useMaterial3: false,
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(3, 25, 49, 1)),
          ),
          home: const Splash()),
    );
  }
}
