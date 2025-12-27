import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campus_one/models/user.dart';

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
      final points = prefs.getInt('user_points') ?? 0;
      final followedTeams = prefs.getStringList('followed_teams') ?? [];
      _currentUser = UserModel(
        id: userId, 
        name: userName, 
        email: userEmail, 
        role: role, 
        points: points,
        followedTeamIds: followedTeams,
      );
      notifyListeners();
    }
  }

  void toggleFollowTeam(String teamId) async {
    if (_currentUser == null) return;
    
    final List<String> currentFollowed = List.from(_currentUser!.followedTeamIds);
    if (currentFollowed.contains(teamId)) {
      currentFollowed.remove(teamId);
    } else {
      currentFollowed.add(teamId);
    }
    
    _currentUser = _currentUser!.copyWith(followedTeamIds: currentFollowed);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('followed_teams', currentFollowed);
    notifyListeners();
  }
  void addPoints(int amount) async {
    if (_currentUser == null) return;
    
    final newPoints = _currentUser!.points + amount;
    _currentUser = _currentUser!.copyWith(points: newPoints);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_points', newPoints);
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? college}) async {
    if (_currentUser == null) return;
    
    _currentUser = _currentUser!.copyWith(name: name);
    
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString('user_name', name);
    notifyListeners();
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
          points: 0,
        );
      } else {
        _currentUser = UserModel(
          id: '1',
          name: 'Nayab Gauhar',
          email: email,
          role: UserRole.student,
          points: 1240,
        );
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', _currentUser!.id);
      await prefs.setString('user_name', _currentUser!.name);
      await prefs.setString('user_email', _currentUser!.email);
      await prefs.setString('user_role', _currentUser!.role == UserRole.student ? 'student' : 'clubAdmin');
      await prefs.setInt('user_points', _currentUser!.points);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password, String department) async {
    // Mock registration logic
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      role: UserRole.student,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', _currentUser!.id);
    await prefs.setString('user_name', _currentUser!.name);
    await prefs.setString('user_email', _currentUser!.email);
    await prefs.setString('user_role', 'student');

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
