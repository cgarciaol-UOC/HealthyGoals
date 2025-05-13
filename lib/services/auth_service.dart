import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  bool get isLoggedIn => _firebaseAuth.currentUser != null;
  User? get currentUser => _firebaseAuth.currentUser;

  // aqui consulta en firebase las preferencias del usuario en cuanto al modo oscuro y notificaciones
  Future<Map<String, dynamic>?> getUserPreferences() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (doc.exists) {
          final data = doc.data();
          return {
            'darkMode': data?['darkMode'] ?? false,
            'notificationsEnabled': data?['notificationsEnabled'] ?? false,
          };
        }
      }
    } catch (e) {
      debugPrint('Error al obtener preferencias del usuario: $e');
    }
    return null;
  }

  // duarda modo claro/oscuro en Firestore
  Future<void> updateDarkMode(bool isDarkMode) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'darkMode': isDarkMode,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Error al actualizar darkMode: $e');
    }
  }

  // guarda el estado de las notificaciones
  Future<void> updateNotificationsEnabled(bool enabled) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'notificationsEnabled': enabled,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Error al actualizar notificationsEnabled: $e');
    }
  }

  // aqui se inicia sesión con correo y contraseña
  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error al iniciar sesión: $e');
      rethrow;
    }
  }

  // aqui se registra el usuario con correo y contraseña
  Future<void> registerWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error al registrar: $e');
      rethrow;
    }
  }

  // metodo para cerrar sesión
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      notifyListeners();
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
      rethrow;
    }
  }

  // metodo para verificar si el usuario tiene un 'inputText' en Firestore
  Future<bool> hasInputText() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        if (doc.exists && doc.data()!.containsKey('inputText')) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error al verificar inputText: $e');
      return false;
    }
  }
}
