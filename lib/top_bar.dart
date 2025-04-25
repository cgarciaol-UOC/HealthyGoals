import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CommonAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          // Icono del logo a la izquierda
          Image.asset(
            'assets/logo.png', // Asegúrate de que el logo está en assets y registrado en pubspec.yaml
            height: 32,
          ),
          const SizedBox(width: 8),
          Text(title),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings'); // Ruta a la página de ajustes
            },
          ),
        ],
      ),
      backgroundColor: Colors.green, // Color opcional
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
