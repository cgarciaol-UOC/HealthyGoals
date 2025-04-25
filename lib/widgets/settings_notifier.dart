import 'package:flutter/material.dart';

class SettingsNotifier extends ChangeNotifier {
  bool _isDarkModeEnabled = false;
  bool _isNotificationsEnabled = false;


  bool get isDarkModeEnabled => _isDarkModeEnabled;
  bool get isNotificationsEnabled => _isNotificationsEnabled;


  void toggleDarkMode() {
    _isDarkModeEnabled = !_isDarkModeEnabled;
    notifyListeners();
  }

  void toggleNotifications() {
    _isNotificationsEnabled = !_isNotificationsEnabled;
    notifyListeners();
  }
}
