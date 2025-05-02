import 'package:flutter/material.dart';


class RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const RecipeCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
