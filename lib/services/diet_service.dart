import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DietService extends ChangeNotifier {
  // Instancia de FirebaseAuth para manejar la autenticación
  final _firebaseAuth = FirebaseAuth.instance;

  // Método para obtener las recetas del usuario desde Firestore
  Future<Map<String, dynamic>?> getRecipes() async {
    final user = FirebaseAuth.instance.currentUser;

    // Verifica si el usuario está logueado
    if (user != null) {
      try {
        // Obtiene el documento del usuario en Firestore
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        // Verifica si el documento existe y contiene la clave 'recipes'
        if (doc.exists && doc.data()!.containsKey('recipes')) {
          return doc.data()!['recipes']; // Devuelve las recetas
        }
      } catch (e) {
        // Captura cualquier error durante la lectura de Firestore
        debugPrint('Error al obtener recetas: $e');
      }
    }
    return null; // Si no hay usuario o no tiene recetas, devuelve null
  }

  // Método para obtener el plan semanal del usuario desde Firestore
  Future<Map<String, dynamic>?> getWeeklyPlan() async {
    final user = FirebaseAuth.instance.currentUser;

    // Verifica si el usuario está logueado
    if (user != null) {
      try {
        // Obtiene el documento del usuario en Firestore
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        // Verifica si el documento existe y contiene la clave 'semanal_planning'
        if (doc.exists && doc.data()!.containsKey('semanal_planning')) {
          return doc.data()!['semanal_planning']; // Devuelve el plan semanal
        }
      } catch (e) {
        // Captura cualquier error durante la lectura de Firestore
        debugPrint('Error al obtener el plan semanal: $e');
      }
    }
    return null; // Si no hay usuario o no tiene plan semanal, devuelve null
  }

  // Método para obtener el plan diario de un día específico desde Firestore
  Future<Map<String, dynamic>?> getDailyPlan(String day) async {
    final user = FirebaseAuth.instance.currentUser;

    // Verifica si el usuario está logueado
    if (user != null) {
      try {
        // Obtiene el documento del usuario en Firestore
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        // Verifica si el documento existe y contiene la clave 'semanal_planning'
        if (doc.exists && doc.data()!.containsKey('semanal_planning')) {
          final weeklyPlan = doc.data()!['semanal_planning'];

          // Verifica si el plan semanal contiene la clave para el día específico
          if (weeklyPlan.containsKey(day)) {
            return weeklyPlan[day]; // Devuelve el plan del día específico
          }
        }
      } catch (e) {
        // Captura cualquier error durante la lectura de Firestore
        debugPrint('Error al obtener el plan diario para el día $day: $e');
      }
    }
    return null; // Si no hay usuario o no tiene plan para el día, devuelve null
  }
}
