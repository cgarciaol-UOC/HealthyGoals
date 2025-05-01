import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../bottom_navigation.dart';

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

    return Scaffold(
      body: child,
      bottomNavigationBar: selectedIndex != -1
    ? BottomNavigation(
    selectedIndex: selectedIndex,
      onItemTapped: (index) {
        context.go(tabs[index]);
      },
    )
        : null,
    );
  }
}
