import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class TOutlinedButtonTheme{
  TOutlinedButtonTheme._();

  /* light theme*/

 static final lightOutlineButtonTheme = OutlinedButtonThemeData(
   style: OutlinedButton.styleFrom(
     shape: RoundedRectangleBorder(),
     foregroundColor: tSecondaryColor,
     side: BorderSide(
         color: tSecondaryColor
     ),


   ),
 );

 /* dark theme*/
  static final darkOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(),
      foregroundColor: tWhiteColor,
      side: BorderSide(
          color: tWhiteColor
      ),


    ),
  );
}