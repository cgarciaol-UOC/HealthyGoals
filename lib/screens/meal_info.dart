import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  List<String> getIngredients(Map<String, dynamic> mealData) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = mealData['strIngredient$i'];
      final measure = mealData['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add('$ingredient - ${measure ?? ''}');
      }
    }
    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = getIngredients(widget.mealData);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const CommonAppBar(title: 'Healthy Goals', showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Recipe Image
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

              /// Recipe Title
              Center(
                child: Text(
                  widget.mealData['strMeal'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Ingredients
              const Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              for (var ingredient in ingredients)
                Text(
                  ingredient,
                  style: const TextStyle(
                    color: Color(0xFF9093A3),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              const SizedBox(height: 20),

              /// Prepare
              const Text(
                'Prepare',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.mealData['strInstructions'],
                style: const TextStyle(
                  color: Color(0xFF9093A3),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),

              /// Change recipe link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ChangeRecipeScreen(
                              title: widget.title,
                              subtitle: widget.mealData['strMeal'],
                              imageUrl: widget.mealData['strMealThumb'],
                              day: widget.day,
                            ),
                      ),
                    );
                    //context.push('/changereceipe');
                  },
                  child: const Text(
                    'Change this recipe',
                    style: TextStyle(
                      color: Color(0xFF9093A3),
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
