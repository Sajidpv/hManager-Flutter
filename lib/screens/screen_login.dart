import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hmanager/db_functions/urls.dart';

import 'package:hmanager/screens/splash_screen.dart';
import 'package:hmanager/widgets/validator.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    if (token != null) {
      alreadyLogged(context);
    }
  }

  final userController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isMatched = true;
  bool isAuthenticating = false;
  String errorText = '';
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Container(
              height: screenHeight * 0.25,
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey.shade300,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  radius: 20,
                  child: Image.asset('assets/hm.png'),
                ),
              )),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(227, 228, 228, 1),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(100))),
              alignment: Alignment.bottomCenter,
              height: screenHeight * 0.75,
              width: screenWidth,
              padding: EdgeInsets.all(screenWidth / 7),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 255, 255, 255)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 13, left: 20, bottom: 13),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(fontSize: 12),
                            ),
                            TextFormField(
                                controller: userController,
                                textInputAction: TextInputAction.next,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(fontSize: 10),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'example@yourmail.com',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    isMatched = true;
                                  });
                                },
                                validator: validateEmail),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(255, 255, 255, 255)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 13, left: 20, bottom: 13),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Password',
                              style: TextStyle(fontSize: 12),
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: passController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              style: const TextStyle(fontSize: 10),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter password',
                              ),
                              validator: validatePassword,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isMatched,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          errorText,
                          style: TextStyle(
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: !isAuthenticating
                            ? () {
                                if (formKey.currentState!.validate()) {
                                  loginUser(context);
                                  //loginCheck();
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 20.0),
                            backgroundColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ))),
                        child: !isAuthenticating
                            ? const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                            : const CircularProgressIndicator()),
                    TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ForgetPassword()));
                      },
                      child: const Text(
                        'Forget Password? Reset Now',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void alreadyLogged(BuildContext cxt) {
    String? myToken = pref.getString('token');
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken!);
    final String role = jwtDecodedToken['type'];
    final String userStatus = jwtDecodedToken['status'];
    final String userId = jwtDecodedToken['_id'];
    if (userStatus == 'Active') {
      if (userStatus == 'Inactive') {
        setState(() {
          isMatched = false;
          errorText = 'The user is Inactive';
        });
      } else {
        print(userId);
        navigateToHomeScreen(role, userId, cxt);
      }
    } else {
      print('Something went wrong');
    }
  }

  void loginUser(BuildContext ctx) async {
    formKey.currentState!.save();

    if (userController.text.isNotEmpty && passController.text.isNotEmpty) {
      var lData = {
        'email': userController.text,
        'password': passController.text
      };

      var response = await http.post(Uri.parse(login),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(lData));
      var jsonRes = jsonDecode(response.body);
      var myToken = jsonRes['token'];
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(myToken);
      final String role = jwtDecodedToken['type'];
      final String userStatus = jwtDecodedToken['status'];
      final String userId = jwtDecodedToken['_id'];
      if (userStatus == 'Active') {
        pref.setString('token', myToken);
        if (userStatus == 'Inactive') {
          setState(() {
            isMatched = false;
            errorText = 'The user is Inactive';
          });
        } else {
          print(userId);
          navigateToHomeScreen(role, userId, ctx);
        }
      } else {
        print('Something went wrong');
      }
    }
  }
}