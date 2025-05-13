import 'package:flutter/material.dart';
import 'package:healthy_goals/custom_theme.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BottomNavigationBar(
        // barra de navegación
        type: BottomNavigationBarType.fixed,
        backgroundColor: customColors.backgroundColor,
        elevation: 10,
        selectedItemColor: customColors.buttonColor,
        unselectedItemColor: customColors.iconColor,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const <BottomNavigationBarItem>[
          // elementos de la barra
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_sharp),
            label: 'MealPlan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chat'),
        ],
      ),
    );
  }
}
