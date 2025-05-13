import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // controla si se muestra la pantalla login o signup
  bool showLogin = true;

  // método para alternar entre la pantalla de login y la de signup
  void toggleScreen() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          showLogin
              ? LogIn(onToggle: toggleScreen)
              : SignUp(onToggle: toggleScreen),
    );
  }
}
