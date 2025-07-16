import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.blue,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.teal,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}