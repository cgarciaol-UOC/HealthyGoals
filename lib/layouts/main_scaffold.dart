import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthy_goals/custom_theme.dart';
import 'package:provider/provider.dart';
import '../bottom_navigation.dart';
import '../services/auth_service.dart';

class MainScaffold extends StatelessWidget {
  // Child es el widget que se pasa para renderizar el contenido principal de la pantalla
  final Widget child;

  // Constructor de la clase que recibe el widget principal (child) para mostrarlo
  const MainScaffold({super.key, required this.child});

  // Rutas principales que se usan en el BottomNavigationBar
  static const tabs = ['/home', '/mealplan', '/workout', '/chat'];

  // Convierte una ubicación (ruta) en un índice de la pestaña seleccionada
  int _locationToIndex(String location) {
    return tabs.indexWhere((tab) => location.startsWith(tab));
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    // Obtiene la ubicación actual (ruta) de la aplicación
    final location = GoRouterState.of(context).uri.toString();

    // Determina el índice de la pestaña seleccionada según la ruta
    final selectedIndex = _locationToIndex(location);

    // Accede al servicio de autenticación para comprobar si el usuario tiene 'inputText'
    final authService = Provider.of<AuthService>(context, listen: false);

    // Si no estamos en la ruta '/chat', renderizamos normalmente con el BottomNavigationBar
    if (location != '/chat') {
      return Scaffold(
        // Renderiza el widget principal (child) como contenido
        body: child,

        // Si la ruta actual es válida para el BottomNavigation, lo renderiza
        bottomNavigationBar:
            selectedIndex != -1
                ? BottomNavigation(
                  selectedIndex:
                      selectedIndex, // Índice de la pestaña seleccionada
                  onItemTapped: (index) {
                    context.go(tabs[index]); // Navega a la ruta correspondiente
                  },
                )
                : null, // Si no es una ruta válida, no muestra el BottomNavigation
      );
    }

    // Si estamos en la ruta '/chat', verificamos si el usuario tiene 'inputText' antes de mostrar el BottomNavigation
    return FutureBuilder<bool>(
      future:
          authService
              .hasInputText(), // Verifica si el usuario tiene 'inputText'
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Muestra una pantalla de carga mientras se obtiene la información
          return Scaffold(
            body: Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(customColors.buttonColor), // Usando el color del tema
            ),
            ),
          );
        }

        // Si tiene 'inputText', mostramos el BottomNavigationBar
        final hasInputText = snapshot.data!;

        return Scaffold(
          // Renderiza el widget principal (child) como contenido
          body: child,

          // Si el usuario tiene 'inputText', se muestra el BottomNavigationBar
          bottomNavigationBar:
              hasInputText
                  ? BottomNavigation(
                    selectedIndex:
                        selectedIndex, // Índice de la pestaña seleccionada
                    onItemTapped: (index) {
                      context.go(
                        tabs[index],
                      ); // Navega a la ruta correspondiente
                    },
                  )
                  : null, // Si no tiene 'inputText', no mostramos el BottomNavigation
        );
      },
    );
  }
}
