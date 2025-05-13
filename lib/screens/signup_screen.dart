import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SignUp extends StatefulWidget {
  final VoidCallback onToggle;

  const SignUp({super.key, required this.onToggle});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';
  bool isLoading = false;

  Future<void> _signUp(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final email = emailController.text;
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          errorMessage = 'Todos los campos son obligatorios';
        });
        return;
      }

      if (!RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
      ).hasMatch(email)) {
        setState(() {
          errorMessage = 'Por favor ingrese un correo electrónico válido.';
        });
        return;
      }

      if (password.length < 6) {
        setState(() {
          errorMessage = 'La contraseña debe tener al menos 6 caracteres.';
        });
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuario creado con éxito')));
      GoRouter.of(
        context,
      ).go('/home'); // Redirigir al usuario después del registro
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Hubo un error al crear el usuario';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 812,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Register Account',
              style: TextStyle(
                color: Color(0xFF45484D),
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Fill your details or continue with social media',
              style: TextStyle(color: Color(0xFF6A6A6A), fontSize: 16),
            ),
            const SizedBox(height: 40),
            _buildInputField('User Name', usernameController),
            const SizedBox(height: 20),
            _buildInputField('Email Address', emailController),
            const SizedBox(height: 20),
            _buildInputField('Password', passwordController, obscure: true),
            const SizedBox(height: 40),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
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
                    _signUp(context);
                  },
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: widget.onToggle,
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already Have Account? ',
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'Log In',
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

  Widget _buildInputField(
    String hint,
    TextEditingController controller, {
    bool obscure = false,
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
