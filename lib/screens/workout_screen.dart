import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthy_goals/custom_theme.dart';
import '../top_bar.dart';
import '../widgets/exercice_card.dart';

class Exercise {
  final String name;
  final String description;
  final String imageUrl;

  Exercise({
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final instructions = (json['instructions'] as List<dynamic>?)
            ?.join('\n') ??
        'No instructions available';

    final List<dynamic>? images = json['images'];
    String imageUrl = '';
    if (images != null && images.isNotEmpty) {
      imageUrl =
          'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/${images[0]}';
    }

    return Exercise(
      name: json['name'] ?? 'Unnamed Exercise',
      description: instructions,
      imageUrl: imageUrl,
    );
  }
}

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  List<Exercise> exercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExercisesFromFirestore();
  }

  Future<void> fetchExercisesFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();
      if (data == null || data['exercises'] == null) {
        throw Exception("No exercises found for this user");
      }

      final List<dynamic> exercisesJson = data['exercises'];

      setState(() {
        exercises = exercisesJson
            .map((json) => Exercise.fromJson(Map<String, dynamic>.from(json)))
            .toList();
            print(exercises);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar ejercicios desde Firestore: $e');
      _loadFallbackExercises();
    }
  }

  void _loadFallbackExercises() {
    final fallback = [
      {
        "name": "Push Ups",
        "instructions": ["3 sets of 15 reps"],
        "images": []
      },
      {
        "name": "Squats",
        "instructions": ["3 sets of 20 reps"],
        "images": []
      }
    ];

    setState(() {
      exercises = fallback.map((json) => Exercise.fromJson(json)).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Scaffold(
      appBar: const CommonAppBar(title: 'Healthy Goals'),
      body: Container(
        color: customColors.backgroundColor,
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          customColors.buttonColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cargando ejercicios...',
                      style: TextStyle(color: customColors.textColor),
                    ),
                  ],
                ),
              )
            : ListView(
                children: exercises
                    .map(
                      (exercise) => ExerciseCard(
                        name: exercise.name,
                        description: exercise.description,
                        imageUrl: exercise.imageUrl,
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
