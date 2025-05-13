import 'package:flutter/material.dart';
import 'package:healthy_goals/services/auth_service.dart';

class SettingsNotifier extends ChangeNotifier {
  final AuthService _authService;

  SettingsNotifier(this._authService);
  // Variable privada para manejar el estado del modo oscuro
  bool _isDarkModeEnabled = false;

  // Variable privada para manejar el estado de las notificaciones
  bool _isNotificationsEnabled = false;

  // Getter para acceder al estado del modo oscuro
  bool get isDarkModeEnabled => _isDarkModeEnabled;

  // Getter para acceder al estado de las notificaciones
  bool get isNotificationsEnabled => _isNotificationsEnabled;

  Future<void> loadSettings() async {
    final prefs = await _authService.getUserPreferences();
    _isDarkModeEnabled = prefs?['darkMode'] ?? false;
    _isNotificationsEnabled = prefs?['notificationsEnabled'] ?? false;
    notifyListeners();
  }

  // Método para alternar entre activar/desactivar el modo oscuro
  Future<void> toggleDarkMode() async {
    // Invertir el valor del modo oscuro
    _isDarkModeEnabled = !_isDarkModeEnabled;
    await _authService.updateDarkMode(_isDarkModeEnabled);

    // Notificar a los oyentes (widgets) que el estado ha cambiado
    notifyListeners();
  }

  // Método para alternar entre activar/desactivar las notificaciones
  Future<void> toggleNotifications() async {
    // Invertir el valor de las notificaciones
    _isNotificationsEnabled = !_isNotificationsEnabled;
    await _authService.updateNotificationsEnabled(_isNotificationsEnabled);

    // Notificar a los oyentes (widgets) que el estado ha cambiado
    notifyListeners();
  }
}
