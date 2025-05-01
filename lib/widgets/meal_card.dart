import 'package:flutter/material.dart';
import 'package:healthy_goals/screens/meal_info.dart';

import '../screens/change_receipe.dart';

class MealCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color badgeColor;

  const MealCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.badgeColor = const Color(0x59000000),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      // Navegar a la página Meal al hacer clic en la tarjeta
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MealScreen()),
      );
    },
    child: Container(
    constraints: BoxConstraints(maxWidth: 336, maxHeight: 110),
    child: Stack(
        children: [
          // Fondo blanco con sombra
          Positioned.fill(
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x193F3B4B),
                    blurRadius: 35,
                    offset: const Offset(0, 10),
                    spreadRadius: -10,
                  )
                ],
              ),
            ),
          ),
          // Botón de editar en la esquina superior derecha
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeRecipeScreen()),
                );
              },
            ),
          ),
          // Badge con color personalizado
          Positioned(
            left: 9,
            top: 11,
            child: Container(
              width: 70,
              height: 50,
              decoration: ShapeDecoration(
                color: badgeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          // Título dentro del badge
          Positioned(
            left: 12,
            top: 28,
            child: SizedBox(
              width: 70,
              height: 30,
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF45484D),
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ),
          ),
          // Contenedor de la imagen
          Positioned(
            left: 112,
            top: 10,
            child: Container(
              width: 140,
              height: 70,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Subtítulo debajo de la imagen
          Positioned(
            left: 113,
            top: 80,
            child: SizedBox(
              width: 148,
              height: 25,
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
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