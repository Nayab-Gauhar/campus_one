import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/services/auth_service.dart';
import 'package:campus_one/services/data_service.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/features/auth/screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => DataService()),
      ],
      child: const CampusOneApp(),
    ),
  );
}

class CampusOneApp extends StatelessWidget {
  const CampusOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusOne',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
