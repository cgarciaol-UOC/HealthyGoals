import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DietService extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;

  // metodo para obtener las recetas del usuario desde Firestore
  Future<Map<String, dynamic>?> getRecipes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        if (doc.exists && doc.data()!.containsKey('recipes')) {
          return doc.data()!['recipes'];
        }
      } catch (e) {
        debugPrint('Error al obtener recetas: $e');
      }
    }
    return null;
  }

  // metodo para obtener el plan semanal del usuario desde Firestore
  Future<Map<String, dynamic>?> getWeeklyPlan() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        if (doc.exists && doc.data()!.containsKey('semanal_planning')) {
          return doc.data()!['semanal_planning'];
        }
      } catch (e) {
        debugPrint('Error al obtener el plan semanal: $e');
      }
    }
    return null;
  }

  // metodo para obtener el plan diario de un día específico desde Firestore
  Future<Map<String, dynamic>?> getDailyPlan(String day) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        if (doc.exists && doc.data()!.containsKey('semanal_planning')) {
          final weeklyPlan = doc.data()!['semanal_planning'];
          if (weeklyPlan.containsKey(day)) {
            return weeklyPlan[day];
          }
        }
      } catch (e) {
        debugPrint('Error al obtener el plan diario para el día $day: $e');
      }
    }
    return null;
  }
}
