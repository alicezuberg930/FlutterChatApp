import 'package:flutter/material.dart';

const textInutDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(color: Colors.white),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  // focusedBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Colors.orange, width: 1),
  // ),
  // enabledBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Colors.orange, width: 1),
  // ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.orange, width: 1),
  ),
);


