import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showSettings;

  const CommonAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.showSettings = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF45484D)),
        onPressed: () {
          context.pop();
        },
      )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo.png', // Asegúrate de que esté en pubspec.yaml
            height: 30,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF45484D),
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        if (showSettings)
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF45484D)),
            onPressed: () {
              context.push('/settings');
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
