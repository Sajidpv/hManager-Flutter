// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:hmanager/screens/users/employess/cutter_home.dart';
import 'package:hmanager/screens/users/employess/finisher_home.dart';

import 'package:hmanager/screens/users/employess/screen_home_production.dart';
import 'package:hmanager/screens/screen_login.dart';
import 'package:hmanager/screens/users/admins/screen_home_admin.dart';

import 'package:hmanager/screens/users/employess/tailer_home.dart';

class Splash extends StatefulWidget {
  const Splash({
    Key? key,
  }) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isSplashFinished = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..addListener(() {
        setState(() {}); // Trigger rebuild to update progress indicator
      });

    controller.repeat(reverse: true);

    Future.delayed(Duration(seconds: 2)).then((_) {
      setState(() {
        isSplashFinished = true;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: isSplashFinished
          ? LoginPage()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: LinearProgressIndicator(
                      value: controller.value,
                      backgroundColor: Colors.white,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Text(
                    'Loading..',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Future<void> pageNavigator(Widget page, BuildContext context) async {
  await Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (ctx) => page,
  ));
}

void navigateToHomeScreen(role, userId, BuildContext context) async {
  const Splash();
  switch (role) {
    case 'Admin':
      pageNavigator(
          AdminHome(
            empId: userId,
          ),
          context);
      break;
    case 'Production':
      pageNavigator(
          ProductionHome(
            empID: userId,
          ),
          context);
      break;
    // case 'Purchaser':
    //   pageNavigator(PurchaseHome(), context);
    //   break;
    // case 'Sales':
    //   pageNavigator(SalesHome(), context);
    //   break;
    // case 'Accountant':
    //   pageNavigator(AccountsHome(), context);
    //   break;
    case 'Tailer':
      pageNavigator(
          TailerHome(
            empID: userId,
          ),
          context);
      break;
    case 'Cutter':
      pageNavigator(CutterHome(empID: userId), context);
      break;
    case 'Finisher':
      pageNavigator(
          FinisherHome(
            empID: userId,
          ),
          context);
      break;
    default:
      pageNavigator(LoginPage(), context);
      break;
  }
}
