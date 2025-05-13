import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthy_goals/custom_theme.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showSettings;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showSettings = true,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return AppBar(
      backgroundColor: customColors.backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading:
          showBackButton
              ? IconButton(
                icon: Icon(Icons.arrow_back, color: customColors.iconColor),
                onPressed: () {
                  context.pop();
                },
              )
              : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logo.png', height: 30),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: customColors.widgetColor,
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
            icon: Icon(Icons.settings, color: customColors.widgetColor),
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
