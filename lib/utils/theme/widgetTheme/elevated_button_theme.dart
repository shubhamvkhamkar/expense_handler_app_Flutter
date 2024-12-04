import 'package:expense_handler/constants/colors.dart';
import 'package:expense_handler/constants/sizes.dart';
import 'package:flutter/material.dart';

class TElevatedButtonTheme{

  TElevatedButtonTheme._(); // to avoid creating instance

// Light Theme
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(

      shape: RoundedRectangleBorder(),
      foregroundColor: tWhiteColor,
      backgroundColor: tSecondaryColor,
      side: BorderSide(
        color: tSecondaryColor,
        width: 1
      ),

    ),
  );


  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
      ),
      shadowColor: tPrimaryColor,
      foregroundColor: tSecondaryColor,
      backgroundColor: tWhiteColor,
        side: BorderSide(
            color: tSecondaryColor,
            width: 1
        ),

    )
  );
}