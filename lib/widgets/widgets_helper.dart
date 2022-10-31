import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle:
      TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 13),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.blueGrey),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.blue),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.red),
  ),
);

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(
        message,
        style: const TextStyle(fontSize: 13),
      ),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}
