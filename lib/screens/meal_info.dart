import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthy_goals/custom_theme.dart';
import '../top_bar.dart';
import 'change_receipe.dart';

class MealScreen extends StatefulWidget {
  final Map<String, dynamic> mealData;
  final String day;
  final String title;

  const MealScreen({
    super.key,
    required this.mealData,
    required this.day,
    required this.title,
  });

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  // funcion para obtener los ingredientes de la receta
  List<String?> getIngredients(Map<String, dynamic> mealData) {
    return List.generate(20, (index) {
      final ingredient = mealData['strIngredient${index + 1}'];
      final measure = mealData['strMeasure${index + 1}'];
      if (ingredient != null && ingredient.isNotEmpty) {
        return '$ingredient - ${measure ?? ''}';
      }
      return null;
    }).where((ingredient) => ingredient != null).toList();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final ingredients = getIngredients(widget.mealData);

    return Scaffold(
      backgroundColor: customColors.backgroundColor,
      appBar: const CommonAppBar(title: 'Healthy Goals', showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de la receta
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.mealData['strMealThumb'],
                    height: 236,
                    width: 174,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Título de la receta
              Center(
                child: Text(
                  widget.mealData['strMeal'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: customColors.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: customColors.textColor,
                ),
              ),
              const SizedBox(height: 10),
              for (var ingredient in ingredients)
                Text(
                  ingredient!,
                  style: TextStyle(
                    color: customColors.iconColor,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                'Prepare',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: customColors.textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.mealData['strInstructions'],
                style: TextStyle(
                  color: customColors.iconColor,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),

              // enlace para cambiar la receta
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    context.push('/changereceipe');
                  },
                  child: Text(
                    'Change this recipe',
                    style: TextStyle(
                      color: customColors.buttonColor,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
