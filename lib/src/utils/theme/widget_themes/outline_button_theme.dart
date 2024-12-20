import 'package:flutter/material.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/constants/sizes.dart';

class ThemeOutlineButton {
  ThemeOutlineButton._();

  static final lightOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      foregroundColor: SecondaryColor,
      side: const BorderSide(color: SecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: ButtonHeight),
    ),
  );
  static final darkOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      foregroundColor: WhiteColor,
      side: const BorderSide(color: WhiteColor),
      padding: const EdgeInsets.symmetric(vertical: ButtonHeight),
    ),
  );
}
