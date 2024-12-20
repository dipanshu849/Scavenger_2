import 'package:flutter/material.dart';
import 'package:scavenger_2/src/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:scavenger_2/src/utils/theme/widget_themes/outline_button_theme.dart';
import 'package:scavenger_2/src/utils/theme/widget_themes/text_field_theme.dart';
import 'package:scavenger_2/src/utils/theme/widget_themes/theme_text.dart';

class AppTheme {
  AppTheme._();
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      // primarySwatch: const MaterialColor(0xFFFFE200, <int, Color>{
      //   50: Color(0x1AFFE200),
      //   100:
      // })
      textTheme: ThemeText.lightTextTheme,
      outlinedButtonTheme: ThemeOutlineButton.lightOutlineButtonTheme,
      elevatedButtonTheme: ThemeElevatedButton.lightElevatedButtonTheme,
      inputDecorationTheme: TextFormFieldTheme.lightInputDecorationTheme);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: ThemeText.darkTextTheme,
    outlinedButtonTheme: ThemeOutlineButton.darkOutlineButtonTheme,
    elevatedButtonTheme: ThemeElevatedButton.darkElevatedButtonTheme,
    inputDecorationTheme: TextFormFieldTheme.darkInputDecorationTheme,
  );
}
