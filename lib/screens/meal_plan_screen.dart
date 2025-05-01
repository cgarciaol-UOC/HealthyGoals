import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bottom_navigation.dart';
import '../top_bar.dart';
import '../widgets/daily_meal_card.dart';
import '../widgets/meal_card.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showShopListPopover() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String shopList = '''
- Avena
- Frutas variadas
- Tofu
- Ensalada
- Yogur
- Nueces
- Verduras para sopa
''';
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.grey),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: shopList));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('List copied to clipboard')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(shopList, style: const TextStyle(fontSize: 16)),
          ),
        );
      },
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _showShopListPopover,
                  child: const Text(
                    'See shop list',
                    style: TextStyle(
                      fontSize: 16,
                      //color: Colors.blueAccent,
                      //decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
