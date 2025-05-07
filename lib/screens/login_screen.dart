import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:healthy_goals/services/auth_service.dart';

class LogIn extends StatefulWidget {
  final VoidCallback onToggle;

  const LogIn({super.key, required this.onToggle});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  void _login() async {
    try {
      await Provider.of<AuthService>(
        context,
        listen: false,
      ).loginWithEmail(emailController.text, passwordController.text);
      final isGoalExisting =
          await Provider.of<AuthService>(context, listen: false).hasInputText();
      if (isGoalExisting) {
        GoRouter.of(context).go('/');
      } else {
        GoRouter.of(context).go('/chat');
      }
    } catch (e) {
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
        height: 812,
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
                  _login();
                  print("Logging in...");
                },
                child: const Text(
                  'LOG IN',
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
