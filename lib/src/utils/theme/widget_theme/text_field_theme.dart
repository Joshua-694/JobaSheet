import 'package:flutter/material.dart';

class jTextFormFieldTheme {
  jTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
    border: OutlineInputBorder(),
    floatingLabelStyle: TextStyle(color: Colors.black),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.black),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme =
      const InputDecorationTheme(
    border: OutlineInputBorder(),
    floatingLabelStyle: TextStyle(color: Colors.blue),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.blue),
    ),
  );
}
