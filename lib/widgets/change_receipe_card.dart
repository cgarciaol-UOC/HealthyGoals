import 'package:flutter/material.dart';
import 'package:healthy_goals/custom_theme.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const RecipeCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: customColors.textColor,
          ),
        ),
      ],
    );
  }
}
