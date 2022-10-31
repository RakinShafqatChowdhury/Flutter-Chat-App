import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/shared/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'pages/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: Constants.apikey,
          appId: Constants.appID,
          messagingSenderId: Constants.messagingSenderId,
          projectId: Constants.projectId),
    );
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: _isSignedIn ? const HomePage() : const LoginPage(),
    );
  }

  void getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then(
      (value) => {
        if (value != null)
          {
            setState(() {
              _isSignedIn = value;
            }),
          }
      },
    );
  }
}
