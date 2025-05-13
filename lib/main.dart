import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthy_goals/widgets/settings_notifier.dart';
import 'package:healthy_goals/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authService = AuthService();

  final settingsNotifier = SettingsNotifier(authService);
  await settingsNotifier.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authService),
        ChangeNotifierProvider(create: (_) => settingsNotifier),
      ],
      child: const HealthyGoalsApp(),
    ),
  );
}
