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
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..addListener(() {});

    controller.repeat(reverse: true);

    super.initState();

    Future.delayed(Duration(seconds: 2)).then((_) {
      setState(() {
        isSplashFinished = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
          // StreamBuilder<User?>(
          //     stream: FirebaseAuth.instance.authStateChanges(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Text(
          //           'Loading...',
          //           style: TextStyle(
          //             fontSize: 20,
          //             color: Color.fromARGB(255, 20, 21, 24),
          //           ),
          //         );
          //       } else if (snapshot.hasData) {
          //         final user = snapshot.data!;
          //         checkUserLogged(context, user.email);
          //         return Container();
          //       } else {
          //         return const LoginPage();
          //       }
          //     },
          //   )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: controller.value,
                    semanticsLabel: 'Circular progress indicator',
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// Future<void> checkUserLogged(context, email) async {
//   try {
//     //final userDoc = FirebaseFirestore.instance.collection('users');
//    // final userSnapshot = await userDoc.where('email', isEqualTo: email).get();

//     if (userSnapshot.docs.isNotEmpty) {
//       var userData = userSnapshot.docs.first.data();
//       String userType = userData['type'];
//       EmployeeModel employe = EmployeeModel.fromJson(userData);
//       navigateToHomeScreen(userType, employe, context);
//     } else {
//       pageNavigator(LoginPage(), context);
//     }
//   } on FirebaseException catch (error) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     showSnackBar(context, error.message ?? 'Authentication Failed');
//   }
// }

Future<void> pageNavigator(Widget page, BuildContext context) async {
  await Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (ctx) => page,
  ));
}

void navigateToHomeScreen(role, userId, BuildContext context) async {
  const Splash();
  switch (role) {
    case 'Admin':
      pageNavigator(AdminHome(), context);
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
