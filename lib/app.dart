import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/fridge_screen.dart';
import 'screens/recipes_screen.dart';
import 'screens/diet_screen.dart';
import 'screens/shopping_list_screen.dart';
import 'screens/workout_screen.dart';
import 'screens/results_screen.dart';
import 'util.dart';
import 'theme.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => AuthScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/fridge', builder: (context, state) => FridgeScreen()),
    GoRoute(path: '/diet', builder: (context, state) => DietScreen()),
    GoRoute(path: '/results', builder: (context, state) => ResultsScreen()),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Montserrat", "Montserrat");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp.router(
      title: 'Healthy Goals',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      routerConfig: _router,
    );
  }
}
