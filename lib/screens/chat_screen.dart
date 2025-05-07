import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_goals/services/auth_service.dart';
import 'package:http/http.dart' as http;
import '../top_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AuthService authService = AuthService();
  final TextEditingController inputTextController = TextEditingController();
  bool? hasExistingGoals;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkExistingGoals();
  }

  Future<void> checkExistingGoals() async {
    final result = await authService.hasInputText();
    setState(() {
      hasExistingGoals = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool? goals = hasExistingGoals;
    if (goals == null || isLoading) {
      // Estado de carga
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: null,
      );
    } else {
      return Scaffold(
        appBar: const CommonAppBar(
          title: 'Healthy Goals',
          showBackButton: false,
        ),
        backgroundColor: const Color(0xFFFBFBFB),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  goals ? 'Change your goals' : 'Specify your goals',
                  style: const TextStyle(
                    color: Color(0xFF45484D),
                    fontSize: 30,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  goals
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
                Container(
                  width: double.infinity,
                  height: 240,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: inputTextController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: goals ? 'I want...' : 'What do you want?',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: Color(0xFF9093A3),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      sendGoals();
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

  // Guarda los objetivos y llama a FastAPI, con validaciones y SnackBars
  Future<void> sendGoals() async {
    final user = FirebaseAuth.instance.currentUser;

    // Validar que el campo no esté vacío
    if (inputTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write your goals before submitting!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (user != null) {
      try {
        final headResponse = await http
            .head(Uri.parse('http://192.168.56.1:8000/'))
            .timeout(
              const Duration(seconds: 2),
            ); // Puedes usar la ruta base o la de análisis
        if (headResponse.statusCode == 200) {
          setState(() {
            isLoading = true; // Mostrar el spinner al iniciar la operación
          });
          // Enviamos el texto al backend FastAPI
          final response = await http
              .post(
                Uri.parse('http://192.168.56.1:8000/analizar-texto/'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({'texto': inputTextController.text}),
              )
              .timeout(const Duration(seconds: 30));

          if (response.statusCode == 200) {
            setState(() {
              isLoading = false; // Mostrar el spinner al iniciar la operación
            });
            final result = jsonDecode(response.body);

            // Guardamos inputText, recipes y planning en Firestore SOLO si todo va bien
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
                  'inputText': inputTextController.text,
                  'recipes': result['recipes'],
                  'semanal_planning': result['semanal_planning'],
                }, SetOptions(merge: true));

            // Mostramos mensaje de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Goals saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            setState(() {
              isLoading = false; // Mostrar el spinner al iniciar la operación
            });
            // Error en la petición al backend
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error processing your goals. (${response.statusCode})',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        setState(() {
          isLoading = false; // Mostrar el spinner al iniciar la operación
        });
        // Error general
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
