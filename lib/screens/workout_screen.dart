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
  final String category;

  Exercise({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final instructions =
        (json['instructions'] as List<dynamic>?)?.join('\n') ??
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
      category: json['category'] ?? 'unknown',
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
  List<Exercise> filteredExercises = [];
  bool _isLoading = true;
  String searchQuery = '';
  String selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    fetchExercisesFromFirestore();
  }

  Future<void> fetchExercisesFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      final data = doc.data();
      if (data == null || data['exercises'] == null) {
        throw Exception("No exercises found for this user");
      }

      final List<dynamic> exercisesJson = data['exercises'];

      setState(() {
        exercises =
            exercisesJson
                .map(
                  (json) => Exercise.fromJson(Map<String, dynamic>.from(json)),
                )
                .toList();
        filteredExercises = exercises;
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
        "images": [],
        "category": "strength",
      },
      {
        "name": "Squats",
        "instructions": ["3 sets of 20 reps"],
        "images": [],
        "category": "strength",
      },
    ];

    setState(() {
      exercises = fallback.map((json) => Exercise.fromJson(json)).toList();
      filteredExercises = exercises;
      _isLoading = false;
    });
  }

  void _showExerciseDialog(Exercise exercise) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: customColors.backgroundColor,
            title: Text(
              exercise.name,
              style: TextStyle(color: customColors.textColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (exercise.imageUrl.isNotEmpty)
                  Image.network(exercise.imageUrl, height: 150),
                const SizedBox(height: 12),
                Text(
                  exercise.description,
                  style: TextStyle(color: customColors.textColor),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cerrar',
                  style: TextStyle(color: customColors.buttonColor),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  void _filterExercises() {
    setState(() {
      filteredExercises =
          exercises.where((exercise) {
            final matchesQuery = exercise.name.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
            final matchesCategory =
                selectedCategory == 'all' ||
                exercise.category == selectedCategory;
            return matchesQuery && matchesCategory;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final categories = ['all', 'strength', 'stretching', 'cardio'];

    return Scaffold(
      appBar: const CommonAppBar(title: 'Healthy Goals'),
      body: Container(
        color: customColors.backgroundColor,
        padding: const EdgeInsets.all(16),
        child:
            _isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          customColors.buttonColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cargando ejercicios...',
                        style: TextStyle(color: customColors.textColor),
                      ),
                    ],
                  ),
                )
                : Column(
                  children: [
                    // Search bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar ejercicio...',
                        hintStyle: TextStyle(
                          color: customColors.textColor.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: customColors.backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: TextStyle(color: customColors.textColor),
                      onChanged: (value) {
                        searchQuery = value;
                        _filterExercises();
                      },
                    ),
                    const SizedBox(height: 10),
                    // Dropdown
                    DropdownButton<String>(
                      value: selectedCategory,
                      dropdownColor: customColors.backgroundColor,
                      style: TextStyle(color: customColors.textColor),
                      items:
                          categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(
                                category[0].toUpperCase() +
                                    category.substring(1),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedCategory = value;
                          _filterExercises();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    // Exercise list
                    Expanded(
                      child: ListView(
                        children:
                            filteredExercises
                                .map(
                                  (exercise) => GestureDetector(
                                    onTap: () => _showExerciseDialog(exercise),
                                    child: ExerciseCard(
                                      name: exercise.name,
                                      description: exercise.description,
                                      imageUrl: exercise.imageUrl,
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
