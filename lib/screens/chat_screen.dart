import 'package:flutter/material.dart';
import '../bottom_navigation.dart';
import '../providers/meal_card_provider.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<WorkoutScreen> {
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
      appBar: AppBar(
        title: const Text('Healthy Goals'),
      ),
      body: Container(
        color: const Color(0xFFFBFBFB),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          children: [
            const Text(
              'Your meal planning for today',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            MealCard(
              title: 'Desayuno',
              subtitle: 'Avena con frutas',
              imageUrl: 'https://placehold.co/179x182?text=Desayuno',
            ),
            const SizedBox(height: 16),
            MealCard(
              title: 'Comida',
              subtitle: 'Ensalada y tofu',
              imageUrl: 'https://placehold.co/179x182?text=Comida',
            ),
            const SizedBox(height: 16),
            MealCard(
              title: 'Merienda',
              subtitle: 'Yogur y nueces',
              imageUrl: 'https://placehold.co/179x182?text=Merienda',
            ),
            const SizedBox(height: 16),
            MealCard(
              title: 'Cena',
              subtitle: 'Sopa de verduras',
              imageUrl: 'https://placehold.co/179x182?text=Cena',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}