import 'package:flutter/material.dart';
import 'package:healthy_goals/screens/meal_info.dart';

import '../custom_theme.dart';
import '../screens/change_receipe.dart';

class MealCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color badgeColor;
  final String day;
  final meal;

  const MealCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.day,
    required this.meal,
    this.badgeColor = const Color(0x59000000),
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return GestureDetector(
      onTap: () {
        // navega a la página Meal al hacer clic en la tarjeta
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MealScreen(day: day, title: title, mealData: meal),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(maxHeight: 110),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: ShapeDecoration(
                  color: customColors.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: customColors.iconColor.withOpacity(0.5),
                      width: 2.0,
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: const Color(0x193F3B4B),
                      blurRadius: 35,
                      offset: const Offset(0, 10),
                      spreadRadius: -10,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.edit, color: customColors.buttonColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChangeRecipeScreen(
                            title: title,
                            subtitle: subtitle,
                            imageUrl: imageUrl,
                            day: day,
                          ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 12,
              top: 28,
              child: SizedBox(
                width: 70,
                height: 30,
                child: Text(
                  title[0].toUpperCase() + title.substring(1),
                  style: TextStyle(
                    color: customColors.textColor,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: (MediaQuery.of(context).size.width * 0.8 - 100) / 2,
              child: Container(
                width: 120,
                height: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width * 0.8 - 80) / 2,
              top: 80,
              child: SizedBox(
                width: 148,
                height: 25,
                child: Text(
                  subtitle,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: customColors.textColor,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
