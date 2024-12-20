import 'package:flutter/material.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/constants/sizes.dart';

class ThemeElevatedButton {
  ThemeElevatedButton._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      foregroundColor: WhiteColor,
      backgroundColor: SecondaryColor,
      side: const BorderSide(color: SecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: ButtonHeight),
    ),
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      foregroundColor: SecondaryColor,
      backgroundColor: WhiteColor,
      side: const BorderSide(color: SecondaryColor),
      padding: const EdgeInsets.symmetric(vertical: ButtonHeight),
    ),
  );
}
