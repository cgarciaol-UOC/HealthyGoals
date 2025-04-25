import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color badgeColor;

  const MealCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.badgeColor = const Color(0x59F29833),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 336,
      height: 106,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 336,
              height: 106,
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
          Positioned(
            left: 8.97,
            top: 11.36,
            child: Container(
              width: 79.38,
              height: 43.91,
              decoration: ShapeDecoration(
                color: badgeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Positioned(
            left: 8.97,
            top: 27.54,
            child: SizedBox(
              width: 84.75,
              height: 12.33,
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF45484D),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ),
          ),
          Positioned(
            left: 153.54,
            top: 4.54,
            child: Container(
              width: 148.56,
              height: 64.72,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Positioned(
            left: 132.46,
            top: -61.48,
            child: Container(
              width: 179.23,
              height: 181.87,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            left: 153.54,
            top: 69.54,
            child: SizedBox(
              width: 148.56,
              height: 18.66,
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
