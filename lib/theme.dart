// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'custom_theme.dart';

class AppTheme {
  static final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(color: Colors.white),
    primaryColor: const Color(0xFFEB5E1B),
    textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
    extensions: const [
      CustomColors(
        buttonColor: Color(0xFFEB5E1B),
        iconColor: Colors.grey,
        textColor: Colors.black,
        backgroundColor: Colors.white,
        appBarColor: Colors.white,
        bottomBarColor: Colors.white,
        widgetColor: Color(0xFF2F353B),
        textColorSame: Colors.black,
        backgroundColorSame: Colors.white,
      ),
    ],
    bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF2F353B),
    appBarTheme: const AppBarTheme(color: Color(0xFF3E3C3C)),
    primaryColor: const Color(0xFFEB5E1B),
    textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)),
    extensions: const [
      CustomColors(
        buttonColor: Color(0xFFEB5E1B),
        iconColor: Color.fromARGB(255, 111, 111, 111),
        textColor: Colors.white,
        backgroundColor: Color(0xFF2F353B),
        appBarColor: Color(0xFF2F353B),
        bottomBarColor: Color(0xFF3E3C3C),
        widgetColor: Colors.white,
        textColorSame: Colors.black,
        backgroundColorSame: Color.fromARGB(255, 219, 219, 219),
      ),
    ],
    bottomAppBarTheme: BottomAppBarTheme(color: const Color(0xFF3E3C3C)),
  );
}
