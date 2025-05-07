import 'package:flutter/material.dart';

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
    return Column(
      children: [
        SizedBox(
          width: 336,
          height: 122,
          child: Stack(
            children: [
              // Fondo blanco con sombra
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 336,
                  height: 122,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
              // Día de la semana
              Positioned(
                left: 19,
                top: 27,
                child: SizedBox(
                  width: 84.75,
                  height: 12.33,
                  child: Text(
                    day, // Día dinámico
                    style: TextStyle(
                      color: const Color(0xFF45484D),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ),
              ),
              // Descripción
              Positioned(
                left: 104,
                top: 5,
                child: SizedBox(
                  width: 223,
                  height: 101,
                  child: Text(
                    description, // Descripción dinámica
                    style: TextStyle(
                      color: const Color(0xFF9093A3),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              // Botón de editar
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    // Navegar a la pantalla de inicio
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
      ],
    );
  }
}
