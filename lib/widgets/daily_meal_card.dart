import 'package:flutter/material.dart';
import 'package:healthy_goals/custom_theme.dart';
import '../screens/home_screen.dart';

class DailyMealCard extends StatelessWidget {
  final String day;
  final String description;

  const DailyMealCard({
    super.key,
    required this.day,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.95, // Ocupa el 80% del ancho de la pantalla
        child: SizedBox(
          height: 122,
          child: Stack(
            children: [
              // Fondo con sombra
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
                        color: Color(0x193F3B4B),
                        blurRadius: 35,
                        offset: Offset(0, 10),
                        spreadRadius: -10,
                      ),
                    ],
                  ),
                ),
              ),
              // Día
              Positioned(
                left: 19,
                top: 27,
                child: Text(
                  day[0].toUpperCase() + day.substring(1),
                  style: TextStyle(
                    color: customColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
              // Descripción
              Positioned(
                left: 104,
                top: 5,
                right: 50, // Deja espacio para el botón
                child: Text(
                  description,
                  style: TextStyle(
                    color: customColors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Botón de editar
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.edit, color: customColors.buttonColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(day: day),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
