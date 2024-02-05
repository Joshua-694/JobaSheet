import 'package:flutter/material.dart';
import 'package:jobasheet/src/utils/theme/widget_theme/text_field_theme.dart';
import 'package:jobasheet/src/utils/theme/widget_themes/text_theme.dart';

class JAppTheme {
  static ThemeData LightTheme = ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      textTheme: JTextTheme.lightTextTheme,
      appBarTheme: AppBarTheme(),
      floatingActionButtonTheme: FloatingActionButtonThemeData(),
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
      inputDecorationTheme: jTextFormFieldTheme.lightInputDecorationTheme);

  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    textTheme: JTextTheme.darkTextTheme,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(),
    floatingActionButtonTheme: FloatingActionButtonThemeData(),
    elevatedButtonTheme:
        ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
    inputDecorationTheme: jTextFormFieldTheme.darkInputDecorationTheme,
  );
}
