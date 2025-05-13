// Importaciones necesarias
import 'dart:convert'; // No se está utilizando, puede eliminarse si no se usa más
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase para la autenticación
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para manejar los datos del usuario
import 'package:healthy_goals/custom_theme.dart';
import '../services/diet_service.dart'; // Servicio para obtener recetas
import '../top_bar.dart'; // Barra superior común
import '../widgets/change_receipe_card.dart'; // Tarjeta de receta
import 'home_screen.dart'; // Pantalla principal después de seleccionar una receta

// Pantalla para cambiar una receta
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
  List<Map<String, dynamic>> recipes = []; // Lista de recetas cargadas
  int? selectedIndex; // Índice de la receta seleccionada
  DietService dietService = DietService(); // Instancia del servicio de dieta

  @override
  void initState() {
    super.initState();
    _loadRecipes(); // Cargar las recetas cuando se inicializa la pantalla
  }

  // Método para cargar las recetas desde el servicio
  Future<void> _loadRecipes() async {
    final recipesData =
        await dietService
            .getRecipes(); // Llamada al servicio para obtener recetas
    print(
      'Respuesta del backend: $recipesData',
    ); // Debug: mostrar la respuesta del backend

    if (recipesData != null && recipesData['meals'] is List) {
      setState(() {
        recipes = List<Map<String, dynamic>>.from(
          recipesData['meals'].map(
            (meal) => {
              'id': meal['idMeal'] ?? 'Unknown', // ID de la receta
              'title': meal['strMeal'] ?? 'Unknown', // Título de la receta
              'image':
                  meal['strMealThumb'] ??
                  'https://placehold.co/293x441', // Imagen de la receta
              'meal': meal, // Detalles completos de la receta
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
      backgroundColor: customColors.backgroundColor, // Fondo de la pantalla
      appBar: const CommonAppBar(
        title: 'Healthy Goals',
        showBackButton: true,
      ), // Barra de navegación
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
             Text(
              'Suggested recipes', // Título de la sección de recetas sugeridas
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: customColors.backgroundColorSame
              ),
            ),
            const SizedBox(height: 16),
            // Vista en cuadrícula para mostrar las recetas
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recipes.length, // Número de recetas a mostrar
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75, // Relación de aspecto de las tarjetas
              ),
              itemBuilder: (context, index) {
                final recipe = recipes[index]; // Receta actual
                final isSelected =
                    selectedIndex ==
                    index; // Verificar si la receta está seleccionada

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex =
                          index; // Actualizar el índice seleccionado
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          isSelected
                              ? Border.all(
                                color: customColors.buttonColor, // Color del borde cuando está seleccionada
                                width: 10,
                              )
                              : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RecipeCard(
                      title: recipe['title']!, // Título de la receta
                      imageUrl:
                          recipe['image']!, // URL de la imagen de la receta
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed:
                    () {}, // Acción cuando se presiona el botón de "Show more"
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
            const SizedBox(height: 80), // Espacio para el botón flotante
          ],
        ),
      ),
      // Botón flotante para seleccionar la receta
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (selectedIndex != null) {
            final selectedRecipe =
                recipes[selectedIndex!]; // Receta seleccionada
            print(
              'Respuesta del backend: $selectedRecipe',
            ); // Debug: mostrar la receta seleccionada
            await _updateRecipeInFirebase(
              selectedRecipe,
            ); // Actualizar la receta en Firebase
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => HomeScreen(
                      day: widget.day,
                    ), // Navegar a la pantalla principal
              ),
            );
          } else {
            // Mostrar un mensaje si no se seleccionó ninguna receta
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a recipe first')),
            );
          }
        },
        backgroundColor: customColors.buttonColor, // Color de fondo del botón flotante
        label: Text(
          'Select this recipe', // Texto del botón flotante
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .centerFloat, // Ubicación del botón flotante
    );
  }

  // Método para actualizar la receta seleccionada en Firebase
  Future<void> _updateRecipeInFirebase(Map<String, dynamic> mealDetails) async {
    final user = FirebaseAuth.instance.currentUser; // Obtener el usuario actual
    print('Respuesta del backend: ${widget.day}');
    print('Respuesta del backend: ${widget.title}');
    final String path =
        "semanal_planning.${widget.day}.${widget.title}"; // Ruta en la base de datos

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {path: mealDetails['meal']}, // Actualizar la receta en la base de datos
      );
    }
  }
}
