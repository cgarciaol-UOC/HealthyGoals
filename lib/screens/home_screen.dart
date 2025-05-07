import 'package:flutter/material.dart';
import 'package:healthy_goals/services/diet_service.dart';
import '../app.dart';
import '../models/meal_model.dart';
import '../top_bar.dart';
import '../widgets/meal_card.dart';

class HomeScreen extends StatefulWidget {
  final String day; // Parámetro para el día

  const HomeScreen({super.key, required this.day});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Meal> meals = [];
  DietService dietService = DietService();
  final List<String> mealOrder = ['desayuno', 'comida', 'merienda', 'cena'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Aquí puedes manejar la navegación entre pantallas
  }

  @override
  void initState() {
    super.initState();
    _loadDailyPlan();
  }

  Future<void> _loadDailyPlan() async {
    print('Respuesta del backend: $widget');

    final dailyPlan = await dietService.getDailyPlan(widget.day);
    print('Respuesta del backend: $dailyPlan');
    if (dailyPlan != null) {
      setState(() {
        meals =
            mealOrder.map((mealName) {
              final mealData = dailyPlan[mealName];

              // si quieres solo la primera comida
              final firstMealJson = mealData;
              print('Respuesta comidita: $firstMealJson');

              final meal = Meal.fromJson(firstMealJson, mealName);

              return Meal(
                idMeal: meal.idMeal,
                strMeal: meal.strMeal,
                strMealThumb: meal.strMealThumb,
                title: mealName,
                strInstructions: meal.strInstructions,
                strCategory: meal.strCategory,
                ingredients: meal.ingredients,
                mealData: firstMealJson,
              );
            }).toList();
      });
    }
    print('Respuesta MIAUMIUA: $meals');
  }

  bool esHoy(String day) {
    final String diaActual = obtenerDiaSemana(DateTime.now().weekday);
    return day.toLowerCase() == diaActual.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    // Si el día recibido no es hoy, mostramos el botón de retroceso
    bool isToday = esHoy(widget.day);
    return Scaffold(
      appBar:
          !isToday
              ? const CommonAppBar(title: 'Healthy Goals', showBackButton: true)
              : const CommonAppBar(title: 'Healthy Goals'),
      body: Container(
        color: const Color(0xFFFBFBFB),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          children: [
            // Título dinámico con el día
            Text(
              'Your meal planning for ${widget.day}', // Aquí cambia el día
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            // Mostrar las comidas del día específico
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

/*class Meal {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Map<String, dynamic> meal;

  Meal({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.meal,
  });
}*/
