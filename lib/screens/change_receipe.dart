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

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

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

    final filteredRecipes =
        recipes.where((recipe) {
          final title = recipe['title']!.toLowerCase();
          return title.contains(searchQuery);
        }).toList();

    return Scaffold(
      backgroundColor: customColors.backgroundColor,
      appBar: const CommonAppBar(title: 'Healthy Goals', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search recipe...',
                prefixIcon: Icon(Icons.search, color: customColors.iconColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customColors.iconColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: customColors.buttonColor),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
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
            // vista en cuadrícula para mostrar las recetas
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredRecipes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                final isSelected = selectedIndex == recipes.indexOf(recipe);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = recipes.indexOf(recipe);
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
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (selectedIndex != null) {
            final selectedRecipe = recipes[selectedIndex!];
            await _updateRecipeInFirebase(selectedRecipe);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(day: widget.day),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a recipe first')),
            );
          }
        },
        backgroundColor: customColors.buttonColor,
        label: const Text(
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
