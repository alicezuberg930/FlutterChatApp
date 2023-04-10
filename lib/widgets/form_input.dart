import 'package:flutter/material.dart';

const textInutDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange, width: 1),
    ));

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 14,
      ),
    ),
    backgroundColor: color,
    duration: const Duration(
      seconds: 5,
    ),
    action: SnackBarAction(
      label: "OK",
      onPressed: () => {},
      textColor: Colors.white,
    ),
  ));
}
