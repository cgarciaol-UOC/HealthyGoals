import 'dart:convert'; // Para convertir objetos a JSON y viceversa
import 'package:cloud_firestore/cloud_firestore.dart'; // Para acceder a Firestore y guardar los datos del usuario
import 'package:firebase_auth/firebase_auth.dart'; // Para manejar la autenticación de Firebase
import 'package:flutter/material.dart'; // Para la UI en Flutter
import 'package:healthy_goals/custom_theme.dart';
import 'package:healthy_goals/services/auth_service.dart'; // Servicio para la autenticación personalizada
import 'package:http/http.dart' as http; // Para hacer peticiones HTTP
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

  // verifica si el usuario ya tiene los objetivos especificados (el prompt)
  Future<void> checkExistingGoals() async {
    final result = await authService.hasInputText();
    setState(() {
      hasExistingGoals = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final bool? goals = hasExistingGoals;
    // si se está verificando el prompt o cargando, se muestra un spinner
    if (goals == null || isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(customColors.buttonColor),
          ),
        ),
        bottomNavigationBar: null,
      );
    } else {
      return Scaffold(
        appBar: CommonAppBar(title: 'Healthy Goals', showBackButton: false),
        backgroundColor: customColors.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  goals ? 'Change your goals' : 'Specify your goals',
                  style: TextStyle(
                    color: customColors.widgetColor,
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
                  style: TextStyle(
                    color: customColors.widgetColor,
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
                    color: customColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: inputTextController,
                    maxLines: null, // permite múltiples líneas
                    decoration: InputDecoration(
                      hintText: goals ? 'I want...' : 'What do you want?',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: customColors.iconColor,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                // este es el botón para enviar los objetivos
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: sendGoals,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColors.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
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

  // metodo para guardar el prompt y hacer la petición al backend
  Future<void> sendGoals() async {
    final user = FirebaseAuth.instance.currentUser;

    if (inputTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write your goals before submitting'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (user != null) {
      try {
        // verifica si el backend está disponible
        final headResponse = await http
            .head(Uri.parse('https://healthygoals.onrender.com/'))
            .timeout(const Duration(seconds: 2));

        if (headResponse.statusCode == 200) {
          setState(() {
            isLoading = true;
          });

          // envia el prompt al backend
          final response = await http
              .post(
                Uri.parse('https://healthygoals.onrender.com/analizar-texto/'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({'text': inputTextController.text}),
              )
              .timeout(const Duration(seconds: 30));

          if (response.statusCode == 200) {
            final result = jsonDecode(response.body);
            // obtiene todos los ejercicios
            final ejerciciosUrl = Uri.parse(
              'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json',
            );
            final ejerciciosResponse = await http.get(ejerciciosUrl);

            List<dynamic> allExercises = [];
            if (ejerciciosResponse.statusCode == 200) {
              allExercises = jsonDecode(ejerciciosResponse.body);
            }
            //TODO filtrar por objetivo

            // guarda los resultados en Firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
                  'inputText': inputTextController.text,
                  'recipes': result['recipes'],
                  'semanal_planning': result['semanal_planning'],
                  'exercises': allExercises,
                }, SetOptions(merge: true));
            setState(() {
              isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Goals saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            setState(() {
              isLoading = false;
            });
            // error
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
          isLoading = false;
        });
        // error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
