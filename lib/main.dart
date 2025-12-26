import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/data_service.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/home_screen.dart';
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
      home: const _AuthWrapper(),
    );
  }
}

class _AuthWrapper extends StatelessWidget {
  const _AuthWrapper();

  @override
  Widget build(BuildContext context) {
    // We can rely on the fact that AuthService notifies listeners when user changes.
    // Provider.of<AuthService>(context) will trigger a rebuild here.
    final auth = context.watch<AuthService>();
    
    // If user is logged in, show HomeScreen. If not, show LoginScreen.
    // However, if we are in the middle of checking (like splash), we might want to handle that.
    // For now, let's assume if currentUser is null, we show LoginScreen (or Splash if loading).
    // AuthService in this app loads synchronously in constructor (simulated) but creates a Future.
    // Let's modify AuthService to expose 'isInitialized' or simple logic.
    // Based on provided AuthService code, it starts _loadUser in constructor and notifies when done.
    // But initially _currentUser is null.
    // So distinct 'loading' state might be needed or we accept a brief LoginScreen flash.
    // But since _loadUser is async, we should probably wait.
    // BUT, I can't easily change AuthService to add 'isLoading' safely without verifying usage.
    // I can just check if _currentUser is null.
    
    // Actually, I should use the Splash Screen logic if I wanted to be perfect.
    // But the current SplashScreen is just a static widget.
    // Let's make _AuthWrapper check auth.
    
    if (auth.currentUser != null) {
      return const HomeScreen(); // Need to import this if not already visible but it is not imported.
    }
    return const LoginScreen(); // Need to import this.
  }
}
