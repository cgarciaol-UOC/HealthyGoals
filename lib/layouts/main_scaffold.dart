import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../bottom_navigation.dart';
import '../services/auth_service.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  static const tabs = ['/home', '/mealplan', '/workout', '/chat'];

  int _locationToIndex(String location) {
    return tabs.indexWhere((tab) => location.startsWith(tab));
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final selectedIndex = _locationToIndex(location);

    final authService = Provider.of<AuthService>(context, listen: false);

    // Si no está en /chat, render normal con bottom nav
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
                : null,
      );
    }

    // Si está en /chat, comprobar inputText
    return FutureBuilder<bool>(
      future: authService.hasInputText(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Pantalla en blanco mientras carga
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final hasInputText = snapshot.data!;

        return Scaffold(
          body: child,
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
