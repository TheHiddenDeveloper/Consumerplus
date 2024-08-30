import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.lightBlue, // Softer color for light mode
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        color: Colors.lightBlue, // Softer color for light mode
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.lightBlue,
          textStyle: const TextStyle(fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.teal, // Softer color for dark mode
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        color: Colors.teal, // Softer color for dark mode
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal,
          textStyle: const TextStyle(fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    );
  }
}
