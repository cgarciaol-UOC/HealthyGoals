import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthy_goals/screens/auth_screen.dart';
import 'package:healthy_goals/screens/change_receipe.dart';
import 'package:healthy_goals/screens/chat_screen.dart';
import 'package:healthy_goals/screens/meal_info.dart';
import 'package:healthy_goals/screens/meal_plan_screen.dart';
import 'package:healthy_goals/screens/workout_screen.dart';
import 'package:healthy_goals/widgets/settings_notifier.dart';
import 'package:healthy_goals/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'layouts/main_scaffold.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  refreshListenable: AuthServiceListener(),
  redirect: (context, state) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final isLoggedIn = authService.isLoggedIn;

    if (!isLoggedIn && state.matchedLocation != '/') {
      return '/';
    }

    if (isLoggedIn && state.matchedLocation == '/') {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AuthScreen()),
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder:
              (context, state) => const HomeScreen(day: 'Monday', meals: []),
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
        GoRoute(path: '/chat', builder: (context, state) => const ChatScreen()),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(),
        ),
      ],
    ),
  ],
);

class HealthyGoalsApp extends StatelessWidget {
  const HealthyGoalsApp({super.key});

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
      themeMode:
          Provider.of<SettingsNotifier>(context).isDarkModeEnabled
              ? ThemeMode.dark
              : ThemeMode.light,
      routerConfig: _router,
    );
  }
}

class AuthServiceListener extends ChangeNotifier {
  AuthServiceListener() {
    _authService.addListener(notifyListeners);
  }

  final _authService = AuthService();

  @override
  void dispose() {
    _authService.removeListener(notifyListeners);
    super.dispose();
  }
}
