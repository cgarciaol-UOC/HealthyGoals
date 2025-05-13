// Importaciones necesarias
import 'package:flutter/material.dart'; // Flutter Material UI
import 'package:healthy_goals/custom_theme.dart';
import 'package:healthy_goals/services/diet_service.dart'; // Servicio para obtener el plan de dieta
import '../app.dart'; // App general
import '../models/meal_model.dart'; // Modelo para la comida
import '../top_bar.dart'; // Barra superior
import '../widgets/meal_card.dart'; // Tarjeta de la comida

class HomeScreen extends StatefulWidget {
  final String day; // El día que recibe como parámetro para mostrar las comidas

  const HomeScreen({super.key, required this.day});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Índice seleccionado para la navegación
  List<Meal> meals = []; // Lista de comidas para el día
  DietService dietService =
      DietService(); // Instancia del servicio para obtener datos del backend
  final List<String> mealOrder = [
    "breakfast",
    "lunch",
    "snack",
    "dinner",
  ]; // Orden de las comidas

  // Método para cambiar el índice seleccionado en la navegación
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Aquí puedes manejar la navegación entre pantallas
  }

  @override
  void initState() {
    super.initState();
    _loadDailyPlan(); // Cargar el plan de comidas para el día
  }

  // Método que carga el plan de comidas del backend para un día específico
  Future<void> _loadDailyPlan() async {
    // Hacemos una llamada al servicio dietético para obtener el plan de comidas
    final dailyPlan = await dietService.getDailyPlan(widget.day);
    print('Respuesta del backend: $dailyPlan');

    if (dailyPlan != null) {
      setState(() {
        // Mapeamos las comidas según el orden y las convertimos en objetos Meal
        meals =
            mealOrder.map((mealName) {
              final mealData =
                  dailyPlan[mealName]; // Datos de la comida para el nombre dado

              // Creación del objeto Meal a partir de los datos obtenidos
              final meal = Meal.fromJson(mealData, mealName);

              // Devolvemos el objeto Meal con los detalles de cada comida
              return Meal(
                idMeal: meal.idMeal,
                strMeal: meal.strMeal,
                strMealThumb: meal.strMealThumb,
                title:
                    mealName, // Título que indica si es desayuno, comida, etc.
                strInstructions: meal.strInstructions,
                strCategory: meal.strCategory,
                ingredients: meal.ingredients,
                mealData: mealData,
              );
            }).toList(); // Convertimos la lista en un List<Meal>
      });
    }
    print('Comidas cargadas: $meals');
  }

  // Función para verificar si el día recibido es hoy
  bool esHoy(String day) {
    final String currentDay = getWeekDay(
      DateTime.now().weekday,
    ); // Obtenemos el día actual
    return day.toLowerCase() ==
        currentDay.toLowerCase(); // Comparamos si el día recibido es hoy
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    bool isToday = esHoy(widget.day); // Comprobamos si el día es hoy

    return Scaffold(
      // Si el día no es hoy, mostramos el botón de retroceso
      appBar:
          !isToday
              ? const CommonAppBar(title: 'Healthy Goals', showBackButton: true)
              : const CommonAppBar(title: 'Healthy Goals'),
      body: Container(
        color: customColors.backgroundColor,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          children: [
            // Título dinámico con el nombre del día
            Text(
              'Your meal planning for ${widget.day}', // Aquí cambia el día según el parámetro recibido
              style: TextStyle(
                color: customColors.textColor,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            // Mostrar las comidas del día especificado
            ...meals.map(
              (meal) => Column(
                children: [
                  MealCard(
                    title: meal.title,
                    subtitle:
                        meal.strMeal, // Nombre de la comida (desayuno, comida, etc.)
                    imageUrl: meal.strMealThumb, // Imagen de la comida
                    day: widget.day, // Día actual
                    meal: meal.mealData, // Datos completos de la comida
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
