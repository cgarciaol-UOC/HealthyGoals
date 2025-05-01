import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final String name;
  final String description;

  const ExerciseCard({Key? key, required this.name, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(name),
        subtitle: Text(description),
        leading: const Icon(Icons.fitness_center),
      ),
    );
  }
}
