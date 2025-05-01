import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../top_bar.dart';
import '../widgets/settings_notifier.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsNotifier = Provider.of<SettingsNotifier>(context); // Obtenemos el estado de Dark Mode
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const CommonAppBar(title: 'Healthy Goals', showBackButton: true, showSettings: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: settingsNotifier.isDarkModeEnabled,
              onChanged: (value) {
                settingsNotifier.toggleDarkMode(); // Alternamos el valor de dark mode
              },
              activeColor: const Color(0xFFF27E33), // Cambié el color activo para que sea consistente
              inactiveTrackColor: const Color(0xFFBDBDBD), // Color de la pista inactiva
              inactiveThumbColor: const Color(0xFF9E9E9E), // Color del thumb inactivo
            ),
            SwitchListTile(
              title: const Text('Notifications'),
              value: settingsNotifier.isNotificationsEnabled,
              onChanged: (value) {
                settingsNotifier.toggleNotifications(); // Alternamos el valor de las notificaciones
              },
              activeColor: const Color(0xFFF27E33), // Igual color para el toggle
              inactiveTrackColor: const Color(0xFFBDBDBD),
              inactiveThumbColor: const Color(0xFF9E9E9E),
            ),
            const SizedBox(height: 34),
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
    return Center(
      child: TextButton(
        onPressed: () {
          // Acción de logout: aquí agregarías el código de logout
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          backgroundColor: const Color(0xFFF27E33), // Color del botón consistente
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.white, // Color de texto en blanco para contrastar
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
