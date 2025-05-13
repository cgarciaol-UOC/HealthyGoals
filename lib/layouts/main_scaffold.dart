import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthy_goals/custom_theme.dart';
import 'package:provider/provider.dart';
import '../bottom_navigation.dart';
import '../services/auth_service.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  // aquí están las rutas correspondientes a cada pestaña del BottomNavigation
  static const tabs = ['/home', '/mealplan', '/workout', '/chat'];

  // convierte una ubicación (ruta) en un índice de pestaña
  int _locationToIndex(String location) {
    return tabs.indexWhere((tab) => location.startsWith(tab));
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    // se obtiene la ubicación actual de la ruta y se determina el índice de la pestaña seleccionada
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _locationToIndex(location);
    final authService = Provider.of<AuthService>(context, listen: false);
    // si no estamos en la ruta '/chat', renderizamos normalmente con el BottomNavigationBar
    if (location != '/chat') {
      return Scaffold(
        body: child,
        bottomNavigationBar:
            selectedIndex != -1
                ? BottomNavigation(
                  selectedIndex: selectedIndex,
                  onItemTapped: (index) {
                    context.go(tabs[index]);
                  },
                )
                : null, // si no es una ruta válida, no muestra el BottomNavigation
      );
    }

    // si estamos en la ruta '/chat', verificamos si el usuario tiene 'inputText' antes de mostrar el BottomNavigation
    return FutureBuilder<bool>(
      future:
          authService
              .hasInputText(), // verifica si el usuario tiene 'inputText'
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // muestra una pantalla de carga mientras se obtiene la información
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  customColors.buttonColor,
                ),
              ),
            ),
          );
        }
        final hasInputText = snapshot.data!;
        return Scaffold(
          body: child,
          // si el usuario tiene 'inputText', se muestra el BottomNavigationBar
          bottomNavigationBar:
              hasInputText
                  ? BottomNavigation(
                    selectedIndex: selectedIndex,
                    onItemTapped: (index) {
                      context.go(tabs[index]);
                    },
                  )
                  : null,
        );
      },
    );
  }
}
