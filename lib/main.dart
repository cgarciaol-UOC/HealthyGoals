import 'package:flutter/material.dart';
import 'package:healty_goals/widgets/settings_notifier.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsNotifier()),
        // Otros proveedores si es necesario...
      ],
      child: const HealthyGoalsApp(),
    ),
  );
}
