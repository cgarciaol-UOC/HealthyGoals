import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healty_goals/screens/auth_screen.dart';
import 'package:healty_goals/screens/change_receipe.dart';
import 'package:healty_goals/screens/chat_screen.dart';
import 'package:healty_goals/screens/meal_info.dart';
import 'package:healty_goals/screens/meal_plan_screen.dart';
import 'package:healty_goals/screens/workout_screen.dart';
import 'package:healty_goals/widgets/settings_notifier.dart';
import 'package:provider/provider.dart';
import 'layouts/main_scaffold.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'bottom_navigation.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child); // Aquí vive la bottom bar
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(day: 'Monday', meals: [], ),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(day: 'Monday', meals: [],),
        ),
        GoRoute(
          path: '/mealplan',
          builder: (context, state) => const MealPlanScreen(),
        ),
        GoRoute(
          path: '/changereceipe',
          builder: (context, state) => const ChangeRecipeScreen(),
        ),
        GoRoute(
          path: '/receipe',
          builder: (context, state) => const MealScreen(),
        ),
        GoRoute(
          path: '/workout',
          builder: (context, state) => const WorkoutScreen(),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) => const ChatScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(),
        ),
      ],
    ),
  ],
);

class HealthyGoalsApp extends StatelessWidget {
  const HealthyGoalsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Healthy Goals',
      theme: ThemeData.light().copyWith(
        primaryColor: const Color(0xFFF27E33),
        appBarTheme: const AppBarTheme(color: Color(0xFFFFFFFF)),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFF27E33),
        appBarTheme: const AppBarTheme(color: Color(0xFF3E3C3C)),
      ),
      themeMode: Provider.of<SettingsNotifier>(context).isDarkModeEnabled
          ? ThemeMode.dark
          : ThemeMode.light,
      routerConfig: _router,
    );
  }
}