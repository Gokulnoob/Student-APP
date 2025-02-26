import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xfff2f9fe);
  static const Color secondary = Color(0xFFdbe4f3);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Colors.grey;
  static const Color red = Color(0xFFec5766);
  static const Color green = Color(0xFF43aa8b);
  static const Color blue = Color(0xFF28c2ff);
  static const Color buttonColor = Color(0xff3e4784);
  static const Color mainFontColor = Color(0xff565c95);
  static const Color arrowBgColor = Color(0xffe4e9f7);

  // Define Light and Dark Theme Data
  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: white,
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      bodyLarge:
          TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: black),
      bodyMedium:
          TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: grey),
      headlineSmall: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: mainFontColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      elevation: 0,
      titleTextStyle:
          TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: black),
    ),
  );

  // Define Dark Theme Data (if needed)
  static ThemeData darkTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: black,
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      bodyLarge:
          TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: white),
      bodyMedium:
          TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: grey),
      headlineSmall: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: mainFontColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      elevation: 0,
      titleTextStyle:
          TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: white),
    ),
  );
}
