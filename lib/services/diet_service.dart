import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DietService extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getRecipes() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (doc.exists && doc.data()!.containsKey('recipes')) {
        return doc.data()!['recipes'];
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getWeeklyPlan() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (doc.exists && doc.data()!.containsKey('semanal_planning')) {
        return doc.data()!['semanal_planning'];
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getDailyPlan(String day) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (doc.exists && doc.data()!.containsKey('semanal_planning')) {
        print('Respuesta del backend sii');
        final weeklyPlan = doc.data()!['semanal_planning'];
        print('Respuesta del backend: $weeklyPlan');
        print('Respuesta del backend: $day');

        if (weeklyPlan.containsKey(day)) {
          return weeklyPlan[day];
        }
      }
    }
    return null;
  }
}
