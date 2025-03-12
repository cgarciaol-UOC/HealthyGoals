import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String result = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados de tu dieta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recomendaciones basadas en tu input: \n\n$result',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Recetas Sugeridas:'), //TODO mostrar recetas sugeridas
            SizedBox(height: 20),
            Text('Plan de Ejercicio:'), //TODO añadir plan ejercicios
          ],
        ),
      ),
    );
  }
}
