import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static ThemeData light = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFF5D9CEC),
        primary: Color(0xFF5D9CEC),
        onPrimary: Colors.white,
        background: Color(0xFFDFECDB),
        secondary: Colors.white,
        onSecondary: Color(0xFF61E757),
      ),
      textTheme: TextTheme(
          headlineMedium: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          labelSmall: GoogleFonts.inter(
              fontWeight: FontWeight.normal,
              fontSize: 20,
              color: Color(0xFFA9A9A9)),
          bodyMedium: GoogleFonts.poppins(
            color: Color(0xFF5D9CEC),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          bodySmall: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          )));
  static ThemeData dark = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF5D9CEC),
          primary: Color(0xFF5D9CEC),
          onPrimary: Colors.white,
          background: Color(0xFF200E32),
          secondary: Colors.white,
          onSecondary: Color(0xFF61E757)),
      textTheme: TextTheme(
          headlineMedium: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          labelSmall: GoogleFonts.inter(
              fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white),
          bodyMedium: GoogleFonts.poppins(
            color: Color(0xFF5D9CEC),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          bodySmall: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          )));
}
