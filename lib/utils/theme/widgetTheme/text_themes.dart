import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme{
 TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
      headlineLarge: GoogleFonts.montserrat(
          color: Colors.black54,
          fontSize: 25

      ),
      headlineSmall: GoogleFonts.montserrat(
      color: Colors.blueAccent.shade100,
      fontSize: 16
  ),
      headlineMedium: GoogleFonts.montserrat(
          color: Colors.black,
          fontSize: 20)
  );
  
  static TextTheme darkTextTheme = TextTheme(

      headlineLarge: GoogleFonts.montserrat(
          color: Colors.black,
          fontSize: 25

      ),
      headlineSmall: GoogleFonts.montserrat(
          color: Colors.green,
          fontSize: 16
      ),
      headlineMedium: GoogleFonts.montserrat(
          color: Colors.blueAccent.shade100,
          fontSize: 20)
  );
}