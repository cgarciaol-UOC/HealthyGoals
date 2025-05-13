import 'dart:convert'; // No se está utilizando, puede eliminarse si no se usa más
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase para la autenticación
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para manejar los datos del usuario
import 'package:healthy_goals/custom_theme.dart';
import '../services/diet_service.dart'; // Servicio para obtener recetas
import '../top_bar.dart'; // Barra superior común
import '../widgets/change_receipe_card.dart'; // Tarjeta de receta
import 'home_screen.dart';

class ChangeRecipeScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String day;

  const ChangeRecipeScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.day,
  });

  @override
  State<ChangeRecipeScreen> createState() => _ChangeRecipeScreenState();
}

class _ChangeRecipeScreenState extends State<ChangeRecipeScreen> {
  List<Map<String, dynamic>> recipes = [];
  int? selectedIndex;
  DietService dietService = DietService();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  // método para cargar las recetas desde el servicio
  Future<void> _loadRecipes() async {
    final recipesData = await dietService.getRecipes();
    if (recipesData != null && recipesData['meals'] is List) {
      setState(() {
        recipes = List<Map<String, dynamic>>.from(
          recipesData['meals'].map(
            (meal) => {
              'id': meal['idMeal'] ?? 'Unknown',
              'title': meal['strMeal'] ?? 'Unknown',
              'image': meal['strMealThumb'] ?? 'https://placehold.co/293x441',
              'meal': meal,
            },
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      backgroundColor: customColors.backgroundColor,
      appBar: const CommonAppBar(title: 'Healthy Goals', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Text(
              'Suggested recipes',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: customColors.textColor,
              ),
            ),
            const SizedBox(height: 16),
            // esta es la vista en cuadrícula para mostrar las recetas
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                final isSelected =
                    selectedIndex ==
                    index; // veerifica si la receta está seleccionada

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index; // actualiza el índice seleccionado
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          isSelected
                              ? Border.all(
                                color: customColors.buttonColor,
                                width: 10,
                              )
                              : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RecipeCard(
                      title: recipe['title']!,
                      imageUrl: recipe['image']!,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Show more...',
                  style: TextStyle(
                    color: customColors.iconColor,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      // este es el botón flotante para seleccionar la receta
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (selectedIndex != null) {
            final selectedRecipe =
                recipes[selectedIndex!]; // receta seleccionada
            await _updateRecipeInFirebase(
              selectedRecipe,
            ); // se actualiza la receta en Firebase
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(day: widget.day),
              ),
            );
          } else {
            // muestra un mensaje si no se seleccionó ninguna receta
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a recipe first')),
            );
          }
        },
        backgroundColor: customColors.buttonColor,
        label: Text(
          'Select this recipe',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // metodo para actualizar la receta seleccionada en Firebase
  Future<void> _updateRecipeInFirebase(Map<String, dynamic> mealDetails) async {
    final user = FirebaseAuth.instance.currentUser;
    final String path = "semanal_planning.${widget.day}.${widget.title}";
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {path: mealDetails['meal']},
      );
    }
  }
}
