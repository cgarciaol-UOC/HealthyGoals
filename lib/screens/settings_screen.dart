import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthy_goals/custom_theme.dart';
import 'package:provider/provider.dart';
import '../top_bar.dart';
import '../widgets/settings_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final settingsNotifier = Provider.of<SettingsNotifier>(
      context,
    ); // Obtenemos el estado de Dark Mode

    return Scaffold(
      backgroundColor: customColors.backgroundColor,
      appBar: const CommonAppBar(
        title: 'Healthy Goals',
        showBackButton: true,
        showSettings: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark Mode toggle
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: settingsNotifier.isDarkModeEnabled,
              onChanged: (value) {
                settingsNotifier
                    .toggleDarkMode(); // Alternamos el valor de dark mode
              },
              activeColor: customColors.buttonColor,
              inactiveTrackColor: const Color(0xFFBDBDBD),
              inactiveThumbColor: const Color(0xFF9E9E9E),
            ),
            // Notifications toggle
            SwitchListTile(
              title: const Text('Notifications'),
              value: settingsNotifier.isNotificationsEnabled,
              onChanged: (value) {
                settingsNotifier
                    .toggleNotifications(); // Alternamos el valor de las notificaciones
              },
              activeColor: customColors.buttonColor,
              inactiveTrackColor: const Color(0xFFBDBDBD),
              inactiveThumbColor: const Color(0xFF9E9E9E),
            ),
            const SizedBox(height: 34),
            // Logout button
            const LogoutButton(),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Center(
      child: TextButton(
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();
            // Redirigir a la pantalla de login después de hacer logout
            GoRouter.of(
              context,
            ).go('/login'); // Redirección explícita a la pantalla de login
          } catch (e) {
            // Si hay un error, puedes mostrar un mensaje
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al cerrar sesión: $e')),
            );
          }
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          backgroundColor: customColors.buttonColor, // Color consistente del botón
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Logout',
          style: TextStyle(
            color: customColors.backgroundColorSame, // Texto en blanco para contraste
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
