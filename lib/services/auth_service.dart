import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  // Instancia de FirebaseAuth para manejar la autenticación
  final _firebaseAuth = FirebaseAuth.instance;

  // Verifica si el usuario está logueado
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  // Devuelve el usuario actual
  User? get currentUser => _firebaseAuth.currentUser;

// Consultar preferencias al iniciar la app
Future<Map<String, dynamic>?> getUserPreferences() async {
  try {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
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

// Guardar modo oscuro o claro en Firestore
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

// Guardar estado de notificaciones en Firestore
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

  // Método para iniciar sesión con correo y contraseña
  Future<void> loginWithEmail(String email, String password) async {
    try {
      // Inicia sesión con el correo y la contraseña proporcionados
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners(); // Notifica a los oyentes cuando el estado cambia
    } catch (e) {
      // Si hay un error al iniciar sesión, se captura aquí
      debugPrint('Error al iniciar sesión: $e');
      rethrow; // Relanza el error para que el caller pueda manejarlo
    }
  }

  // Método para registrar un nuevo usuario con correo y contraseña
  Future<void> registerWithEmail(String email, String password) async {
    try {
      // Registra al usuario con el correo y la contraseña proporcionados
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners(); // Notifica a los oyentes cuando el estado cambia
    } catch (e) {
      // Si hay un error al registrar, se captura aquí
      debugPrint('Error al registrar: $e');
      rethrow; // Relanza el error para que el caller pueda manejarlo
    }
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    try {
      // Cierra la sesión del usuario actual
      await _firebaseAuth.signOut();
      notifyListeners(); // Notifica a los oyentes cuando el estado cambia
    } catch (e) {
      // Si hay un error al cerrar sesión, se captura aquí
      debugPrint('Error al cerrar sesión: $e');
      rethrow; // Relanza el error para que el caller pueda manejarlo
    }
  }

  // Método para traducir un texto de un idioma a otro
  Future<String> translateText(String text, String targetLang) async {
    try {
      final url = Uri.parse('https://libretranslate.com/translate');

      // Realiza una solicitud POST para traducir el texto
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': text,
          'source':
              'en', // Idioma fuente (puedes hacer que sea dinámico si lo necesitas)
          'target': targetLang, // Idioma destino (pasado como parámetro)
          'format': 'text',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['translatedText']; // Devuelve el texto traducido
      } else {
        throw Exception('Error al traducir texto: ${response.statusCode}');
      }
    } catch (e) {
      // Captura cualquier error durante el proceso de traducción
      debugPrint('Error al traducir: $e');
      rethrow; // Relanza el error para que el caller pueda manejarlo
    }
  }

  // Método para verificar si el usuario tiene un 'inputText' en Firestore
  Future<bool> hasInputText() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Obtiene el documento del usuario en Firestore
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        // Verifica si el documento existe y si contiene la clave 'inputText'
        if (doc.exists && doc.data()!.containsKey('inputText')) {
          return true; // Si tiene 'inputText', devuelve true
        } else {
          return false; // Si no tiene 'inputText', devuelve false
        }
      }
      return false; // Si no hay usuario logueado, devuelve false
    } catch (e) {
      // Captura cualquier error durante la verificación
      debugPrint('Error al verificar inputText: $e');
      return false; // Devuelve false en caso de error
    }
  }
}
