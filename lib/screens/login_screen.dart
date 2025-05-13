import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:healthy_goals/services/auth_service.dart';

class LogIn extends StatefulWidget {
  final VoidCallback
  onToggle; // Callback para cambiar entre pantalla de login y registro

  const LogIn({super.key, required this.onToggle});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController emailController =
      TextEditingController(); // Controlador para el campo de email
  final TextEditingController passwordController =
      TextEditingController(); // Controlador para el campo de contraseña
  String errorMessage = ''; // Variable para mostrar mensajes de error

  // Método de login
  void _login() async {
    try {
      // Intentamos hacer login con el servicio de autenticación
      await Provider.of<AuthService>(
        context,
        listen: false,
      ).loginWithEmail(emailController.text, passwordController.text);

      // Verificamos si el usuario tiene datos de plan semanal
      final isGoalExisting =
          await Provider.of<AuthService>(context, listen: false).hasInputText();

      // Si ya tiene un plan, lo llevamos a la pantalla principal, de lo contrario, al chat
      if (isGoalExisting) {
        GoRouter.of(context).go('/');
      } else {
        GoRouter.of(context).go('/chat');
      }
    } catch (e) {
      // Si ocurre un error, mostramos el mensaje
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 812, // Altura fija para mantener la consistencia en la interfaz
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Welcome Back!',
              style: TextStyle(
                color: Color(0xFF45484D),
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Fill your details or continue with social media',
              style: TextStyle(color: Color(0xFF6A6A6A), fontSize: 16),
            ),
            const SizedBox(height: 40),
            // Campos de entrada de email y contraseña
            _buildInputField('Email Address', emailController),
            const SizedBox(height: 20),
            _buildInputField('Password', passwordController, obscure: true),
            const SizedBox(height: 40),
            // Botón de login
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF27E33),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _login(); // Llamamos a la función de login al presionar el botón
                  print("Logging in...");
                },
                child: const Text(
                  'LOG IN',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Botón para cambiar a la pantalla de registro
            Center(
              child: TextButton(
                onPressed: widget.onToggle, // Cambiar pantalla al presionar
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'New User? ',
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'Create Account',
                        style: TextStyle(
                          color: Color(0xFF45484D),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Mostrar error si ocurre un problema con el login
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget para construir los campos de entrada de texto (email y contraseña)
  Widget _buildInputField(
    String hint,
    TextEditingController controller, {
    bool obscure = false, // Si es true, el campo será de tipo contraseña
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
