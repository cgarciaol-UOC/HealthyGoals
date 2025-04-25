import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Healthy Goals')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/fridge'),
              child: Text('Mi nevera'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/recipes'),
              child: Text('Recetas'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/diet'),
              child: Text('Mi Dieta'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/shopping'),
              child: Text('Lista de Compras'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/workout'),
              child: Text('Ejercicio'),
            ),
          ],
        ),
      ),
    );
  }
}
