import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> loginWithEmail(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  Future<void> registerWithEmail(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }

  Future<String> translateText(String text, String targetLang) async {
    final url = Uri.parse('https://libretranslate.com/translate');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': text,
        'source': 'en', // Idioma origen
        'target': 'es', //targetLang, // Idioma destino, por ejemplo 'es'
        'format': 'text',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['translatedText'];
    } else {
      throw Exception('Error al traducir texto: ${response.statusCode}');
    }
  }

  Future<bool> hasInputText() async {
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
      ;
    }
    return false;
  }
}
