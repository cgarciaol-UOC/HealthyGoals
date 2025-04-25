import 'package:flutter/material.dart';
import '../bottom_navigation.dart';
import '../widgets/meal_card.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({Key? key}) : super(key: key);

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375,
          height: 812,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: const Color(0xFFFBFBFB)),
          child: Stack(
            children: [
              Positioned(
                left: 375,
                top: 768,
                child: Container(
                  transform:
                      Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(3.14),
                  width: 375,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, 0.00),
                      end: Alignment(0.00, 1.00),
                      colors: [
                        const Color(0xFF071429),
                        const Color(0x00C4C4C4),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 742,
                child: Container(
                  width: 375,
                  height: 70,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.50),
                        topRight: Radius.circular(30.50),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 42,
                top: 787,
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: const Color(0xFFF27E33),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
              ),
              Positioned(
                left: 216,
                top: 787,
                child: Text(
                  'Exercices',
                  style: TextStyle(
                    color: const Color(0xFFA8A8AA),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
              ),
              Positioned(
                left: 120,
                top: 755,
                child: Container(
                  width: 59,
                  height: 44,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 59,
                          height: 44,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 32,
                                child: Text(
                                  'Meal plan',
                                  style: TextStyle(
                                    color: const Color(0xFFA8A8AA),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 17,
                        top: 4,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("https://placehold.co/26x26"),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 264,
                top: 57,
                child: Transform(
                  transform:
                      Matrix4.identity()
                        ..translate(0.0, 0.0)
                        ..rotateZ(-3.14),
                  child: Text(
                    'Healthy Goals',
                    style: TextStyle(
                      color: const Color(0xFF45484D),
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 36,
                top: 21,
                child: Container(
                  width: 44.24,
                  height: 43,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/44x43"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 307,
                top: 787,
                child: Text(
                  'Chat',
                  style: TextStyle(
                    color: const Color(0xFFA8A8AA),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 125,
                child: Container(
                  width: 332,
                  height: 541,
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
              Positioned(
                left: 43.71,
                top: 485.67,
                child: SizedBox(
                  width: 285.56,
                  height: 111.42,
                  child: Text(
                    ' Lorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsum',
                    style: TextStyle(
                      color: const Color(0xFF9093A3),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 43.71,
                top: 336.35,
                child: SizedBox(
                  width: 285.56,
                  height: 111.42,
                  child: Text(
                    ' Lorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsum',
                    style: TextStyle(
                      color: const Color(0xFF9093A3),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 132,
                top: 142,
                child: SizedBox(
                  width: 227,
                  height: 15,
                  child: Text(
                    'Lorem ipsum',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 113,
                top: 178,
                child: Container(
                  width: 144,
                  height: 84,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 92.56,
                top: 92.32,
                child: Container(
                  width: 173.73,
                  height: 236.04,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/174x236"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 43.71,
                top: 298.44,
                child: SizedBox(
                  width: 146.79,
                  height: 21.43,
                  child: Text(
                    'Ingredients',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 43.71,
                top: 447.76,
                child: SizedBox(
                  width: 146.79,
                  height: 21.43,
                  child: Text(
                    'Prepare',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 230,
                top: 685,
                child: SizedBox(
                  width: 169,
                  height: 21,
                  child: Text(
                    'Change this recipt',
                    style: TextStyle(
                      color: const Color(0xFF9093A3),
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
      ],
    );
  }
}
