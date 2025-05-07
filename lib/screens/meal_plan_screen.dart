import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_goals/services/diet_service.dart';
import '../models/meal_model.dart';
import '../top_bar.dart';
import '../widgets/daily_meal_card.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? weeklyPlan;
  DietService dietService = DietService();
  final List<String> dayOrder = [
    'lunes',
    'martes',
    'miercoles',
    'jueves',
    'viernes',
    'sabado',
    'domingo',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadWeeklyPlan();
  }

  Future<void> _loadWeeklyPlan() async {
    final plan = await dietService.getWeeklyPlan();
    print('Respuesta del backend: $plan');

    if (plan != null) {
      setState(() {
        weeklyPlan = plan;
      });
    }
  }

  String normalizeIngredient(String ingredient) {
    ingredient = ingredient.toLowerCase();
    if (ingredient.endsWith('s')) {
      ingredient = ingredient.substring(0, ingredient.length - 1);
    }
    return ingredient;
  }

  Future<void> showShopListPopover() async {
    if (weeklyPlan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontraron datos para el plan semanal'),
        ),
      );
      return;
    }

    final Map<String, dynamic> shopList = {};

    weeklyPlan?.forEach((day, meals) {
      if (meals is Map<String, dynamic>) {
        meals.forEach((mealType, mealData) {
          if (mealData is Map<String, dynamic>) {
            print("APA");
            print(mealData);
            //final mealList = mealData['meals'];
            //if (mealList is List) {
            //for (final meal in mealList) {
            //if (meal is Map<String, dynamic>) {
            final mealObj = Meal.fromJson(mealData, mealType);

            mealObj.ingredients.forEach((ingredient, measure) {
              final normalizedIngredient = normalizeIngredient(ingredient);

              if (shopList.containsKey(normalizedIngredient)) {
                shopList[normalizedIngredient] =
                    shopList[normalizedIngredient]! + measure;
              } else {
                shopList[normalizedIngredient] = measure;
              }
            });
          }
          //}
          //}
          //}
        });
      }
    });

    print('🛒 Lista de la compra generada: $shopList');

    //shopList = shopList.toSet().toList(); // Eliminar duplicados

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.grey),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: shopList.entries
                          .map((e) => '${e.value} ${e.key}')
                          .join('\n'),
                    ),
                  );
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
            child: Text(
              shopList.entries.map((e) => '${e.value} ${e.key}').join('\n'),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Healthy Goals', showBackButton: false),
      body: Container(
        color: const Color(0xFFFBFBFB),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    showShopListPopover();
                  },
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
            if (weeklyPlan != null)
              ...dayOrder.where((day) => weeklyPlan!.containsKey(day)).map((
                day,
              ) {
                final meals = weeklyPlan![day];

                String description = '';

                // Recorrer las comidas que quieres mostrar
                for (var mealType in [
                  'desayuno',
                  'comida',
                  'merienda',
                  'cena',
                ]) {
                  if (meals.containsKey(mealType)) {
                    final mealData = meals[mealType];
                    if (mealData is Map<String, dynamic>) {
                      if (mealData.isNotEmpty) {
                        final mealName = mealData['strMeal'] ?? 'Sin nombre';
                        description += '$mealType: $mealName\n';
                      } else {
                        description += '$mealType: (sin plato)\n';
                      }
                    }
                  } else {
                    description += '$mealType: (no disponible)\n';
                  }
                }
                return DailyMealCard(day: day, description: description.trim());
              }).toList()
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
