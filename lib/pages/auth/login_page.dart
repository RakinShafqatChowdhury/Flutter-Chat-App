import 'package:chat_app/pages/auth/register_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/widgets_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "GroupChat",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Lets see what you are upto",
                          style: TextStyle(fontSize: 14),
                        ),
                        Image.asset('assets/login.png'),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            label: const Text('Email'),
                            prefixIcon: Icon(
                              Icons.email_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!.toLowerCase())
                                ? null
                                : "Please enter valid email id";
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                              label: const Text('Password'),
                              prefixIcon: Icon(
                                Icons.lock_rounded,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            validator: (value) {
                              if (value!.length < 6)
                                return "Password must be at least 6 characters";
                              else
                                return null;
                            }),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: login,
                            child: const Text(
                              "Sign In",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Create now",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const RegisterPage());
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = !_isLoading;
      });
      await authService.createUserWithEmailAndPassword(email, password).then(
        (value) async {
          if (value == true) {
            QuerySnapshot snapshot = await DatabaseService(
                    uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(email);
            await HelperFunction.saveUserLoggedInStatus(true);
            await HelperFunction.saveUserNameSF(snapshot.docs[0]['fullName']);
            await HelperFunction.saveUserEmailSF(email);
            nextScreenReplace(context, const HomePage());
          } else {
            showSnackBar(context, Colors.red, value);
            setState(() {
              _isLoading = !_isLoading;
            });
          }
        },
      );
    }
  }
}
