import 'package:flutter/material.dart';
import '../top_bar.dart';
import '../widgets/change_receipe_card.dart';

class ChangeRecipeScreen extends StatefulWidget {
  const ChangeRecipeScreen({super.key});

  @override
  State<ChangeRecipeScreen> createState() => _ChangeRecipeScreenState();
}

class _ChangeRecipeScreenState extends State<ChangeRecipeScreen> {
  final List<Map<String, String>> recipes = List.generate(
    6,
        (index) => {
      'title': 'lorem ipsum',
      'image': 'https://placehold.co/293x441',
    },
  );

  int? selectedIndex; // Guarda el índice seleccionado

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
                      border: isSelected
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
        onPressed: () {
          Navigator.pop(context); // Vuelve atrás
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
}
