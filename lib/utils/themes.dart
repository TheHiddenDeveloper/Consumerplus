import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.lightBlue, // Softer color for light mode
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal, // Softer color for dark mode
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
