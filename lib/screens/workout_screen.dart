import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../top_bar.dart';
import '../widgets/exercice_card.dart';

class Exercise {
  final String name;
  final String description;

  Exercise({required this.name, required this.description});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(name: json['name'], description: json['description']);
  }
}

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int _selectedIndex = 0;
  List<Exercise> exercises = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    try {
      final response = await http.get(
        Uri.parse('https://tu-api.com/exercises'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          setState(() {
            exercises = data.map((json) => Exercise.fromJson(json)).toList();
          });
        } else {
          _loadFallbackExercises();
        }
      } else {
        _loadFallbackExercises();
      }
    } catch (e) {
      debugPrint('Error al cargar ejercicios: $e');
      _loadFallbackExercises();
    }
  }

  void _loadFallbackExercises() {
    final ex = [
      {"name": "Push Ups", "description": "3 sets of 15 reps"},
      {"name": "Squats", "description": "3 sets of 20 reps"},
    ];

    setState(() {
      exercises = ex.map((json) => Exercise.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Exercise List', showBackButton: true),
      body: Container(
        color: const Color(0xFFFBFBFB),
        padding: const EdgeInsets.all(16),
        child:
            exercises.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                  children:
                      exercises
                          .map(
                            (exercise) => ExerciseCard(
                              name: exercise.name,
                              description: exercise.description,
                            ),
                          )
                          .toList(),
                ),
      ),
    );
  }
}
