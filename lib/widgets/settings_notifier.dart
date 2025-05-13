import 'package:flutter/material.dart';
import 'package:healthy_goals/services/auth_service.dart';

class SettingsNotifier extends ChangeNotifier {
  final AuthService _authService;

  SettingsNotifier(this._authService);
  bool _isDarkModeEnabled = false;
  bool _isNotificationsEnabled = false;
  bool get isDarkModeEnabled => _isDarkModeEnabled;
  bool get isNotificationsEnabled => _isNotificationsEnabled;

  // metodo para cargar las preferencias del usuario
  Future<void> loadSettings() async {
    final prefs = await _authService.getUserPreferences();
    _isDarkModeEnabled = prefs?['darkMode'] ?? false;
    _isNotificationsEnabled = prefs?['notificationsEnabled'] ?? false;
    notifyListeners();
  }

  // metodo para alternar entre activar/desactivar el modo oscuro
  Future<void> toggleDarkMode() async {
    _isDarkModeEnabled = !_isDarkModeEnabled;
    await _authService.updateDarkMode(_isDarkModeEnabled);
    // notifica a los oyentes que el estado ha cambiado
    notifyListeners();
  }

  // metodo para alternar entre activar/desactivar las notificaciones
  Future<void> toggleNotifications() async {
    _isNotificationsEnabled = !_isNotificationsEnabled;
    await _authService.updateNotificationsEnabled(_isNotificationsEnabled);
    notifyListeners();
  }
}
