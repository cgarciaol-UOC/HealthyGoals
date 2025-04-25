import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'bottom_navigation.dart';

class HealthyGoalsApp extends StatelessWidget {
  const HealthyGoalsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthy Goals',
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFFF27E33),
        appBarTheme: const AppBarTheme(color: Color(0xFFF27E33)),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFF27E33),
        appBarTheme: const AppBarTheme(color: Color(0xFFF27E33)),
      ),
      home: const HomeScreen(),
    );
  }
}