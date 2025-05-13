import 'package:flutter/material.dart';
import 'package:healthy_goals/custom_theme.dart';

class ExerciseCard extends StatelessWidget {
  final String name;
  final String description;
  final String imageUrl;

  const ExerciseCard({
    super.key,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: customColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: customColors.iconColor.withOpacity(0.5),
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            imageUrl.isNotEmpty
                ? Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
                : const Icon(Icons.fitness_center, size: 50),
            const SizedBox(width: 16),
            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: customColors.textColor,
                    ),
                  ),
                  // Text(
                  //   description,
                  //   maxLines: 3,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
