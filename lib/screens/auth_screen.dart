// Importaciones necesarias
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

// Pantalla de autenticación que maneja el login y el registro
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Controla qué pantalla se muestra (Login o Signup)
  bool showLogin = true;

  // Método para alternar entre la pantalla de login y la de signup
  void toggleScreen() {
    setState(() {
      showLogin =
          !showLogin; // Cambia el estado para mostrar la pantalla opuesta
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          showLogin
              // Si showLogin es verdadero, muestra la pantalla de login
              ? LogIn(onToggle: toggleScreen)
              // Si showLogin es falso, muestra la pantalla de signup
              : SignUp(onToggle: toggleScreen),
    );
  }
}
