import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_goals/custom_theme.dart';
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
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
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

  // funcion para cargar el plan semanal del backend
  Future<void> _loadWeeklyPlan() async {
    try {
      final plan = await dietService.getWeeklyPlan();
      if (plan != null) {
        setState(() {
          weeklyPlan = plan;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error on loading semanal planning')),
      );
    }
  }

  // funcion para normalizar los ingredientes si es necesario
  String normalizeIngredient(String ingredient) {
    ingredient = ingredient.toLowerCase();
    if (ingredient.endsWith('s')) {
      ingredient = ingredient.substring(0, ingredient.length - 1);
    }
    return ingredient;
  }

  Future<void> showShopListPopover() async {
    if (weeklyPlan == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No data found')));
      return;
    }

    final Map<String, dynamic> shopList = {};
    // aqui se generan los ingredientes de la lista de la compra
    weeklyPlan?.forEach((day, meals) {
      if (meals is Map<String, dynamic>) {
        meals.forEach((mealType, mealData) {
          if (mealData is Map<String, dynamic>) {
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
        });
      }
    });
    //aqui se muestra el popover con la lista de la compra
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final customColors = Theme.of(context).extension<CustomColors>()!;
        return AlertDialog(
          backgroundColor: customColors.backgroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.copy, color: customColors.buttonColor),
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
                icon: Icon(Icons.close, color: customColors.buttonColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              shopList.entries.map((e) => '${e.value} ${e.key}').join('\n'),
              style: TextStyle(fontSize: 16, color: customColors.textColor),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    if (weeklyPlan == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(customColors.buttonColor),
          ),
        ),
        bottomNavigationBar: null,
      );
    } else {
      return Scaffold(
        appBar: const CommonAppBar(
          title: 'Healthy Goals',
          showBackButton: false,
        ),
        body: Container(
          color: customColors.backgroundColor,
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
                    child: Text(
                      'See shop list',
                      style: TextStyle(
                        fontSize: 16,
                        color: customColors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ...dayOrder.where((day) => weeklyPlan!.containsKey(day)).map((
                day,
              ) {
                final meals = weeklyPlan![day];

                String description = '';
                for (var mealType in [
                  'breakfast',
                  'lunch',
                  'snack',
                  'dinner',
                ]) {
                  if (meals.containsKey(mealType)) {
                    final mealData = meals[mealType];
                    if (mealData is Map<String, dynamic>) {
                      final mealName = mealData['strMeal'] ?? 'No name';
                      description += '$mealType: $mealName\n';
                    }
                  } else {
                    description += '$mealType: (no disponible)\n';
                  }
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: DailyMealCard(
                    day: day,
                    description: description.trim(),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    }
  }
}
