import 'package:flutter/material.dart';
import '../bottom_navigation.dart';
import '../top_bar.dart';
import '../widgets/meal_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 0;

  // Simula si el usuario ya tiene objetivos guardados o no
  bool hasExistingGoals = false; // cámbialo según lo que te llegue de datos

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Healthy Goals', showBackButton: false),
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Título dinámico
              Text(
                hasExistingGoals ? 'Change your goals' : 'Specify your goals',
                style: const TextStyle(
                  color: Color(0xFF45484D),
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Descripción dinámica
              Text(
                hasExistingGoals
                    ? 'Edit your goals, be careful you cannot restart your old input once you click on submit!'
                    : 'Here you can write your nutritional and weight goals. Don’t worry, you can edit later!',
                style: const TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Chat messages container
              Container(
                width: double.infinity,
                height: 240,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    hasExistingGoals ? 'I want...' : 'What do you want?',
                    style: TextStyle(
                      color: Color(0xFF9093A3),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Botón de enviar mensaje
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // acción del botón
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF27E33),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
