import 'package:expense_handler/utils/theme/widgetTheme/elevated_button_theme.dart';
import 'package:expense_handler/utils/theme/widgetTheme/outline_button_theme.dart';
import 'package:expense_handler/utils/theme/widgetTheme/text_themes.dart';
import 'package:flutter/material.dart';

class TAppTheme{

  TAppTheme._();
  static  ThemeData lightTheme =  ThemeData(
      brightness: Brightness.light,
      textTheme: TTextTheme.lightTextTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.lightOutlineButtonTheme,

      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme

  );
  static  ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      textTheme: TTextTheme.darkTextTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.darkOutlineButtonTheme,
      elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme

  );

}