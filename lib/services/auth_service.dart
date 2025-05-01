import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> loginWithEmail(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  Future<void> registerWithEmail(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}
