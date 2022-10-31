import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
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
                          "Create account and start chatting",
                          style: TextStyle(fontSize: 14),
                        ),
                        Image.asset('assets/register.png'),
                        TextFormField(
                            decoration: textInputDecoration.copyWith(
                              label: const Text('Full Name'),
                              prefixIcon: Icon(
                                Icons.person_rounded,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                fullName = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isNotEmpty)
                                return null;
                              else
                                return "Please input your name";
                            }),
                        const SizedBox(
                          height: 15,
                        ),
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
                            onPressed: register,
                            child: const Text(
                              "Register",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Login Now",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const LoginPage());
                                  },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = !_isLoading;
      });
      await authService
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then(
            (value) async {
              if (value == true)
                {
                  await HelperFunction.saveUserLoggedInStatus(true);
                  await HelperFunction.saveUserNameSF(fullName);
                  await HelperFunction.saveUserEmailSF(email);
                  nextScreenReplace(context, const HomePage());
                }
              else
                {
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
