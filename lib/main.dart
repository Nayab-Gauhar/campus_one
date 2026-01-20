import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_one/services/auth_service.dart';
import 'package:campus_one/services/events_service.dart';
import 'package:campus_one/services/societies_service.dart';
import 'package:campus_one/services/sports_service.dart';
import 'package:campus_one/services/notifications_service.dart';
import 'package:campus_one/core/theme/app_theme.dart';
import 'package:campus_one/features/auth/screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Authentication
        ChangeNotifierProvider(create: (_) => AuthService()),
        
        // Feature-specific services
        ChangeNotifierProvider(create: (_) => EventsService()),
        ChangeNotifierProvider(create: (_) => SocietiesService()),
        ChangeNotifierProvider(create: (_) => SportsService()),
        ChangeNotifierProvider(create: (_) => NotificationsService()),
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
