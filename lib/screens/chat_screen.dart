// Importaciones necesarias
import 'dart:convert'; // Para convertir objetos a JSON y viceversa
import 'package:cloud_firestore/cloud_firestore.dart'; // Para acceder a Firestore y guardar los datos del usuario
import 'package:firebase_auth/firebase_auth.dart'; // Para manejar la autenticación de Firebase
import 'package:flutter/material.dart'; // Para la UI en Flutter
import 'package:healthy_goals/custom_theme.dart';
import 'package:healthy_goals/services/auth_service.dart'; // Servicio para la autenticación personalizada
import 'package:http/http.dart' as http; // Para hacer peticiones HTTP
import '../top_bar.dart'; // Barra superior común

// Pantalla de chat donde el usuario puede especificar sus objetivos
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AuthService authService =
      AuthService(); // Instancia de AuthService para la autenticación
  final TextEditingController inputTextController =
      TextEditingController(); // Controlador para el texto ingresado
  bool?
  hasExistingGoals; // Variable para verificar si el usuario ya tiene objetivos
  bool isLoading = false; // Para gestionar el estado de carga

  @override
  void initState() {
    super.initState();
    checkExistingGoals(); // Verificar si el usuario tiene objetivos al iniciar
  }

  // Verifica si el usuario ya tiene objetivos especificados
  Future<void> checkExistingGoals() async {
    final result =
        await authService
            .hasInputText(); // Consulta si el usuario tiene objetivos guardados
    setState(() {
      hasExistingGoals = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final bool? goals =
        hasExistingGoals; // Variable para manejar la condición de si el usuario tiene objetivos

    // Si estamos verificando los objetivos o cargando, mostramos un indicador de carga
    if (goals == null || isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              customColors.buttonColor,
            ), // Usando el color del tema
          ),
        ), // Indicador de carga
        bottomNavigationBar: null,
      );
    } else {
      return Scaffold(
        appBar: CommonAppBar(
          title: 'Healthy Goals', // Título de la app en la barra
          showBackButton: false, // No mostramos el botón de retroceso
        ),
        backgroundColor: customColors.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Título de la pantalla, cambia según si el usuario tiene objetivos o no
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
                // Descripción de la pantalla, también cambia según si el usuario tiene objetivos
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
                // Caja de texto para ingresar los objetivos
                Container(
                  width: double.infinity,
                  height: 240,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: customColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: inputTextController, // Controlador de texto
                    maxLines: null, // Permite múltiples líneas
                    decoration: InputDecoration(
                      hintText:
                          goals
                              ? 'I want...'
                              : 'What do you want?', // Texto de ayuda
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: customColors.iconColor,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center, // Centrado del texto
                  ),
                ),
                const SizedBox(height: 32),
                // Botón para enviar los objetivos
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: sendGoals, // Método para enviar los objetivos
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColors.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'SUBMIT', // Texto del botón
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

  // Método para guardar los objetivos y hacer la petición al backend
  Future<void> sendGoals() async {
    final user = FirebaseAuth.instance.currentUser; // Obtiene el usuario actual

    // Validación para asegurarse de que el campo de texto no esté vacío
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
        // Verificar si el backend está disponible
        final headResponse = await http
            .head(Uri.parse('https://healthygoals.onrender.com/'))
            .timeout(const Duration(seconds: 2));

        if (headResponse.statusCode == 200) {
          setState(() {
            isLoading = true; // Mostrar spinner de carga
          });

          // Enviar los objetivos al backend (FastAPI)
          final response = await http
              .post(
                Uri.parse('https://healthygoals.onrender.com/analizar-texto/'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({'text': inputTextController.text}),
              )
              .timeout(const Duration(seconds: 30));

          if (response.statusCode == 200) {
            final result = jsonDecode(response.body);
            final ejerciciosUrl = Uri.parse(
              'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json',
            );
            final ejerciciosResponse = await http.get(ejerciciosUrl);

            List<dynamic> allExercises = [];

            if (ejerciciosResponse.statusCode == 200) {
              allExercises = jsonDecode(ejerciciosResponse.body);
            }

            // Filtrado simple según el objetivo
            /*final Map<String, List<String>> objetivoToBodyParts = {
                'perder_peso': ['cardio', 'lower legs', 'upper legs'],
                'ganar_musculo': ['chest', 'upper arms', 'back', 'shoulders'],
                'mantener_peso': ['core', 'cardio', 'upper legs']
              };

              final partesPermitidas = objetivoToBodyParts[result['objetivo']] ?? [];

              ejerciciosFiltrados = allExercises.where((exercise) {
                final bodyPart = exercise['bodyPart']?.toString().toLowerCase();
                return partesPermitidas.contains(bodyPart);
              }).toList();
            }
            print(ejerciciosFiltrados);*/

            // Guardar los resultados en Firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
                  'inputText': inputTextController.text, // Objetivo del usuario
                  'recipes': result['recipes'], // Recetas generadas
                  'semanal_planning':
                      result['semanal_planning'], // Plan semanal
                  'exercises': allExercises, // Aquí se guardan los ejercicios
                }, SetOptions(merge: true));
            setState(() {
              isLoading = false; // Detener spinner de carga
            });
            // Mostrar mensaje de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Goals saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            setState(() {
              isLoading = false; // Detener spinner de carga
            });
            // Error al procesar los objetivos
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
          isLoading = false; // Detener spinner de carga
        });
        // Error general al conectar con el backend
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
