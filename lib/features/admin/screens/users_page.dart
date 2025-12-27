import 'package:flutter/material.dart';
import 'package:campus_one/core/theme/app_theme.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Administration', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            Text('Manage Users', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -1.0, color: AppTheme.textPrimary)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 70,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: AppTheme.surfaceColor, shape: BoxShape.circle),
              child: const Icon(Icons.people_alt_rounded, size: 64, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 32),
            const Text(
              'Directory Sync Pending',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            const Text(
              'User management features are currently being\nprovisioned for your administration group.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
