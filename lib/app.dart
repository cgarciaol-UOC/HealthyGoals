import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthy_goals/screens/auth_screen.dart';
import 'package:healthy_goals/screens/change_receipe.dart';
import 'package:healthy_goals/screens/chat_screen.dart';
import 'package:healthy_goals/screens/meal_info.dart';
import 'package:healthy_goals/screens/meal_plan_screen.dart';
import 'package:healthy_goals/screens/workout_screen.dart';
import 'package:healthy_goals/theme.dart';
import 'package:healthy_goals/widgets/settings_notifier.dart';
import 'package:healthy_goals/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'layouts/main_scaffold.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

// función para obtener el día de la semana como string
final String currentDay = getWeekDay(DateTime.now().weekday);

// funcion para convertir el número del día en el nombre del día
String getWeekDay(int numberDay) {
  switch (numberDay) {
    case 1:
      return 'monday';
    case 2:
      return 'tuesday';
    case 3:
      return 'wednesday';
    case 4:
      return 'thursday';
    case 5:
      return 'friday';
    case 6:
      return 'saturday';
    case 7:
      return 'sunday';
    default:
      return 'monday';
  }
}

// configuración de gorouter para la navegación
final GoRouter _router = GoRouter(
  initialLocation: '/', //ruta inicial
  refreshListenable: AuthServiceListener(),
  redirect: (context, state) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final isLoggedIn = authService.isLoggedIn;

    // redirige si el usuario no está logueado y no está en la ruta '/':
    if (!isLoggedIn && state.matchedLocation != '/') {
      return '/';
    }
    //si está logueado y está en la ruta '/', redirige a la página correspondiente
    if (isLoggedIn && state.matchedLocation == '/') {
      final isGoalExisting =
          await Provider.of<AuthService>(context, listen: false).hasInputText();
      return isGoalExisting ? '/home' : '/chat';
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
          builder: (context, state) {
            final String currentDay = getWeekDay(DateTime.now().weekday);
            return HomeScreen(day: currentDay);
          },
        ),
        GoRoute(
          path: '/mealplan',
          builder: (context, state) => const MealPlanScreen(),
        ),
        GoRoute(
          path: '/changereceipe',
          builder:
              (context, state) => const ChangeRecipeScreen(
                title: '',
                subtitle: '',
                imageUrl: '',
                day: '',
              ),
        ),
        GoRoute(
          path: '/receipe',
          builder:
              (context, state) =>
                  const MealScreen(mealData: {}, day: '', title: ''),
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          Provider.of<SettingsNotifier>(context).isDarkModeEnabled
              ? ThemeMode.dark
              : ThemeMode.light,
      routerConfig: _router,
    );
  }
}

// listener de authservice que notifica a los widgets cuando el estado de autenticación cambia
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
