import 'package:flutter/material.dart';
import '../bottom_navigation.dart';
import '../top_bar.dart';
import '../widgets/daily_meal_card.dart';
import '../widgets/meal_card.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MealPlanScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Aquí puedes manejar la navegación entre pantallas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Healthy Goals', showBackButton: true),
      body: Container(
        color: const Color(0xFFFBFBFB),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          children: [
            DailyMealCard(day: 'Monday', description: 'Lorem ipsum dolor sit amet'),
            DailyMealCard(day: 'Tuesday', description: 'Consectetur adipiscing elit'),
            DailyMealCard(day: 'Wednesday', description: 'Sed do eiusmod tempor incididunt'),
            DailyMealCard(day: 'Thursday', description: 'Ut enim ad minim veniam'),
            DailyMealCard(day: 'Friday', description: 'Quis nostrud exercitation ullamco laboris'),
            DailyMealCard(day: 'Saturday', description: 'Duis aute irure dolor in reprehenderit'),
            DailyMealCard(day: 'Sunday', description: 'Excepteur sint occaecat cupidatat non proident'),
          ],
        ),
      ),
    );
  }
}