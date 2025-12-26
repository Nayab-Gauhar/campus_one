import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  AuthService() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final userName = prefs.getString('user_name');
    final userEmail = prefs.getString('user_email');
    final userRoleString = prefs.getString('user_role');

    if (userId != null && userName != null && userEmail != null && userRoleString != null) {
      final role = userRoleString == 'student' ? UserRole.student : UserRole.clubAdmin;
      _currentUser = UserModel(id: userId, name: userName, email: userEmail, role: role);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    // Mock login logic
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == 'admin@haldia.edu' || email == 'student@haldia.edu') {
      if (email == 'admin@haldia.edu') {
        _currentUser = UserModel(
          id: '2',
          name: 'Admin User',
          email: email,
          role: UserRole.clubAdmin,
        );
      } else {
        _currentUser = UserModel(
          id: '1',
          name: 'Nayab Gauhar',
          email: email,
          role: UserRole.student,
        );
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', _currentUser!.id);
      await prefs.setString('user_name', _currentUser!.name);
      await prefs.setString('user_email', _currentUser!.email);
      await prefs.setString('user_role', _currentUser!.role == UserRole.student ? 'student' : 'clubAdmin');

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
