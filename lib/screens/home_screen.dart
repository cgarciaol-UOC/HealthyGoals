import 'package:flutter/material.dart';
import 'package:healthy_goals/custom_theme.dart';
import 'package:healthy_goals/services/diet_service.dart';
import '../app.dart';
import '../models/meal_model.dart';
import '../top_bar.dart';
import '../widgets/meal_card.dart';

class HomeScreen extends StatefulWidget {
  final String day;
  const HomeScreen({super.key, required this.day});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Meal> meals = [];
  DietService dietService = DietService();
  final List<String> mealOrder = [
    "breakfast",
    "lunch",
    "snack",
    "dinner",
  ]; // este es el orden de las comidas

  // metodo para cambiar el índice seleccionado en la navegación
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDailyPlan();
  }

  // metodo que carga el plan de comidas del backend para un día específico
  Future<void> _loadDailyPlan() async {
    final dailyPlan = await dietService.getDailyPlan(widget.day);

    if (dailyPlan != null) {
      setState(() {
        // mapeamos las comidas según el orden y las convertimos en objetos Meal
        meals =
            mealOrder.map((mealName) {
              final mealData = dailyPlan[mealName];
              final meal = Meal.fromJson(mealData, mealName);
              return Meal(
                idMeal: meal.idMeal,
                strMeal: meal.strMeal,
                strMealThumb: meal.strMealThumb,
                title: mealName,
                strInstructions: meal.strInstructions,
                strCategory: meal.strCategory,
                ingredients: meal.ingredients,
                mealData: mealData,
              );
            }).toList();
      });
    }
  }

  // función para verificar si el día recibido es hoy
  bool isTodayFunc(String day) {
    final String currentDay = getWeekDay(DateTime.now().weekday);
    return day.toLowerCase() == currentDay.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    bool isToday = isTodayFunc(widget.day);

    return Scaffold(
      appBar:
          !isToday
              ? const CommonAppBar(title: 'Healthy Goals', showBackButton: true)
              : const CommonAppBar(title: 'Healthy Goals'),
      body: Container(
        color: customColors.backgroundColor,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          children: [
            Text(
              'Your meal planning for ${widget.day}', // aquí cambia el día según el parámetro recibido
              style: TextStyle(
                color: customColors.textColor,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            // aqui se muestran las comidas segun el dia especifico
            ...meals.map(
              (meal) => Column(
                children: [
                  MealCard(
                    title: meal.title,
                    subtitle: meal.strMeal,
                    imageUrl: meal.strMealThumb,
                    day: widget.day,
                    meal: meal.mealData,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
