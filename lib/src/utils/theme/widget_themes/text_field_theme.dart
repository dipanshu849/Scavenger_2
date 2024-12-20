import 'package:flutter/material.dart';
import 'package:scavenger_2/src/constants/colors.dart';

class TextFormFieldTheme {
  TextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: SecondaryColor),
          prefixIconColor: SecondaryColor,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: SecondaryColor)));

  static InputDecorationTheme darkInputDecorationTheme =
      const InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: PrimaryColor),
          prefixIconColor: PrimaryColor,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: PrimaryColor)));
}
