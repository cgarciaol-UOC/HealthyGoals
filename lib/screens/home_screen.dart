import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../top_bar.dart';
import '../bottom_navigation.dart';
import '../widgets/meal_card.dart';

class HomeScreen extends StatefulWidget {
  final String day; // Parámetro para el día
  final List<Meal> meals; // Lista de recetas

  const HomeScreen({Key? key, required this.day, required this.meals}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Meal> mealsTest = [
    Meal(
      title: 'Desayuno',
      subtitle: 'Avena con frutas',
      imageUrl: 'https://media.istockphoto.com/id/469048787/es/foto/aperitivos.jpg?s=612x612&w=0&k=20&c=SDFRNvap0LxwFcqA2naAs0UlKJ-NdU9CCtOME5lJ4Kw=',
    ),
    Meal(
      title: 'Comida',
      subtitle: 'Ensalada y tofu',
      imageUrl: 'https://media.istockphoto.com/id/469048787/es/foto/aperitivos.jpg?s=612x612&w=0&k=20&c=SDFRNvap0LxwFcqA2naAs0UlKJ-NdU9CCtOME5lJ4Kw=',
    ),
    Meal(
      title: 'Merienda',
      subtitle: 'Yogur y nueces',
      imageUrl: 'https://media.istockphoto.com/id/469048787/es/foto/aperitivos.jpg?s=612x612&w=0&k=20&c=SDFRNvap0LxwFcqA2naAs0UlKJ-NdU9CCtOME5lJ4Kw=',
    ),
    Meal(
      title: 'Cena',
      subtitle: 'Sopa de verduras',
      imageUrl: 'https://media.istockphoto.com/id/469048787/es/foto/aperitivos.jpg?s=612x612&w=0&k=20&c=SDFRNvap0LxwFcqA2naAs0UlKJ-NdU9CCtOME5lJ4Kw=',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Aquí puedes manejar la navegación entre pantallas
  }

  @override
  Widget build(BuildContext context) {
    // Si el día recibido no es hoy, mostramos el botón de retroceso
    bool isToday = false; //widget.day == DateFormat('yyyy-MM-dd').format(DateTime.now());
    return Scaffold(
      appBar:
      !isToday? const CommonAppBar(title: 'Healthy Goals', showBackButton: true) :
        const CommonAppBar(title: 'Healthy Goals'),
      body: Container(
        color: const Color(0xFFFBFBFB),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          children: [
            // Título dinámico con el día
            Text(
              'Your meal planning for ${widget.day}',  // Aquí cambia el día
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            // Mostrar las recetas pasadas como lista
            ...mealsTest.map((meal) => Column(// cambiar por widget.meals
              children: [
                MealCard(
                  title: meal.title,
                  subtitle: meal.subtitle,
                  imageUrl: meal.imageUrl,
                ),
                const SizedBox(height: 16),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class Meal {
  final String title;
  final String subtitle;
  final String imageUrl;

  Meal({required this.title, required this.subtitle, required this.imageUrl});
}
/*
MealCard(
              title: 'Desayuno',
              subtitle: 'Avena con frutas',
              imageUrl: 'https://media.istockphoto.com/id/469048787/es/foto/aperitivos.jpg?s=612x612&w=0&k=20&c=SDFRNvap0LxwFcqA2naAs0UlKJ-NdU9CCtOME5lJ4Kw=',
            ),
            MealCard(
              title: 'Comida',
              subtitle: 'Ensalada y tofu',
              imageUrl: 'https://media.istockphoto.com/id/469048787/es/foto/aperitivos.jpg?s=612x612&w=0&k=20&c=SDFRNvap0LxwFcqA2naAs0UlKJ-NdU9CCtOME5lJ4Kw=',
            ),
            const SizedBox(height: 16),
            MealCard(
              title: 'Merienda',
              subtitle: 'Yogur y nueces',
              imageUrl: 'https://media.istockphoto.com/id/469048787/es/foto/aperitivos.jpg?s=612x612&w=0&k=20&c=SDFRNvap0LxwFcqA2naAs0UlKJ-NdU9CCtOME5lJ4Kw=',
            ),
            const SizedBox(height: 16),
            MealCard(
              title: 'Cena',
              subtitle: 'Sopa de verduras',
              imageUrl: 'https://media.istockphoto.com/id/469048787/es/foto/aperitivos.jpg?s=612x612&w=0&k=20&c=SDFRNvap0LxwFcqA2naAs0UlKJ-NdU9CCtOME5lJ4Kw=',
            ),
          */