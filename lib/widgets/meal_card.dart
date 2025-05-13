import 'package:flutter/material.dart';
import 'package:healthy_goals/screens/meal_info.dart';

import '../custom_theme.dart';
import '../models/meal_model.dart';
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
        // Navegar a la página Meal al hacer clic en la tarjeta
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MealScreen(day: day, title: title, mealData: meal),
          ),
        );
      },
      child: Container(
        width:
            MediaQuery.of(context).size.width *
            0.85, // 80% del ancho de pantalla
        constraints: BoxConstraints(maxHeight: 110),
        child: Stack(
          children: [
            // Fondo blanco con sombra
            Positioned.fill(
              child: Container(
                decoration: ShapeDecoration(
                  color: customColors.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      // Aquí defines el borde
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
            // Botón de editar en la esquina superior derecha
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
            // Badge con color personalizado
            /*Positioned(
              left: 9,
              top: 11,
              child: Container(
                width: 70,
                height: 50,
                decoration: ShapeDecoration(
                  color: customColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),*/
            // Título dentro del badge (primera letra mayúscula)
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
            // Contenedor de la imagen (centrada)
            Positioned(
              top: 10,
              left:
                  (MediaQuery.of(context).size.width * 0.8 - 100) /
                  2, // Centrado horizontal
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
            // Subtítulo debajo de la imagen (centrado)
            Positioned(
              left:
                  (MediaQuery.of(context).size.width * 0.8 - 80) /
                  2, // Centrado horizontal
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
