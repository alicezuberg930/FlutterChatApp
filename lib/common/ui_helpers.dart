import 'package:flutter/material.dart';

class UIHelpers {
  static nextScreen(context, page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static nextScreenReplace(context, page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
  }

  static showSnackBar(context, color, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "OK",
          onPressed: () => {},
          textColor: Colors.white,
        ),
      ),
    );
  }
}
