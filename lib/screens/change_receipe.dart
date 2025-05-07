import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/diet_service.dart';
import '../top_bar.dart';
import '../widgets/change_receipe_card.dart';
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
  int? selectedIndex; // Guarda el índice seleccionado
  DietService dietService = DietService();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final recipesData = await dietService.getRecipes();
    print('Respuesta del backend: $recipesData');

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
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const CommonAppBar(title: 'Healthy Goals', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Suggested recipes',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
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
                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          isSelected
                              ? Border.all(
                                color: const Color(0xFFF27E33),
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
                child: const Text(
                  'Show more...',
                  style: TextStyle(
                    color: Color(0xFF9093A3),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80), // espacio para el botón flotante
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (selectedIndex != null) {
            final selectedRecipe = recipes[selectedIndex!];
            print('Respuesta del backend: $selectedRecipe');
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
        backgroundColor: const Color(0xFFF27E33),
        label: const Text(
          'Select this recipe',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _updateRecipeInFirebase(Map<String, dynamic> mealDetails) async {
    final user = FirebaseAuth.instance.currentUser;
    print('Respuesta del backend: ${widget.day}');
    print('Respuesta del backend: ${widget.title}');
    final String path = "semanal_planning.${widget.day}.${widget.title}";

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {path: mealDetails['meal']},
      );
    }
  }
}
