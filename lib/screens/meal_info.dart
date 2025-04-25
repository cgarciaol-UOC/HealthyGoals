import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../top_bar.dart';


  class MealScreen extends StatefulWidget {
  const MealScreen({Key? key}) : super(key: key);

  @override
  _MealScreenState createState() => _MealScreenState();
  }

  class _MealScreenState extends State<MealScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const CommonAppBar(title: 'Healthy Goals', showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Recipe Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    "https://placehold.co/174x236",
                    height: 236,
                    width: 174,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Recipe Title
              Center(
                child: Text(
                  'Lorem ipsum',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Ingredients
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Lorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsum',
                style: TextStyle(
                  color: Color(0xFF9093A3),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),

              /// Prepare
              Text(
                'Prepare',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Lorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsumLorem ipsum',
                style: TextStyle(
                  color: Color(0xFF9093A3),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),

              /// Change recipe link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    context.push('/changereceipe'); // o context.go('/otraRuta');
                  },
                  child: Text(
                    'Change this recipe',
                    style: TextStyle(
                      color: Color(0xFF9093A3),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
