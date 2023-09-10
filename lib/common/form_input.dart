import 'package:flutter/material.dart';

const textInutDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: Colors.white),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  // focusedBorder: OutlineInputBorder(
  //   borderRadius: BorderRadius.all(Radius.circular(15)),
  //   borderSide: BorderSide(color: Colors.blue),
  // ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: Colors.blue),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: Colors.red, width: 1),
  ),
);
