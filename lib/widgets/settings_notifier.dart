import 'package:flutter/material.dart';

class DarkModeNotifier extends ChangeNotifier {
  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  void toggleDarkMode() {
    _isDarkModeEnabled = !_isDarkModeEnabled;
    notifyListeners();
  }
}
