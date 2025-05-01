import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatelessWidget {
  final VoidCallback onToggle;

  SignUp({super.key, required this.onToggle});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';

  Future<void> _signUp(BuildContext context) async {
    try {
      final email = emailController.text;
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        return;
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Usuario creado con éxito')));
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'Hubo un error al crear el usuario';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
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
                onPressed: onToggle,
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
