import 'package:flutter/material.dart';
import 'package:campus_one/models/sports.dart';

/// Service responsible for managing sports-related data and operations
class SportsService extends ChangeNotifier {
  final List<SportsModel> _sportsData = [];
  final List<SportsTeam> _sportsTeams = [];
  bool _isLoading = false;

  List<SportsModel> get sportsData => _sportsData;
  List<SportsTeam> get sportsTeams => _sportsTeams;
  bool get isLoading => _isLoading;

  SportsService() {
    _initializeSports();
  }

  Future<void> _initializeSports() async {
    _sportsData.clear();
    _sportsTeams.clear();

    _sportsData.addAll([
      SportsModel(
        id: 'm1',
        title: 'Inter-College Cup Final',
        type: 'Match',
        sportName: 'Football',
        dateTime: DateTime.now().add(const Duration(minutes: 45)),
        venue: 'Main Stadium',
        status: 'Ongoing',
        teamIds: const ['t1', 't2'],
        homeScore: 2,
        awayScore: 1,
      ),
      SportsModel(
        id: 'm2',
        title: 'T-20 Semester Blast',
        type: 'Match',
        sportName: 'Cricket',
        dateTime: DateTime.now().add(const Duration(days: 1, hours: 4)),
        venue: 'College Oval',
        status: 'Upcoming',
        teamIds: const ['t3', 't4'],
        homeScore: 0,
        awayScore: 0,
      ),
    ]);

    _sportsTeams.addAll([
      const SportsTeam(
        id: 't1',
        name: 'Haldia Lions',
        sport: 'Football',
        captain: 'Rahul S.',
        logoUrl: 'https://images.unsplash.com/photo-1518091043644-c1d445bb5120?auto=format&fit=crop&q=80&w=200',
        colorHex: 'D4FF33',
      ),
      const SportsTeam(
        id: 't2',
        name: 'City Hawks',
        sport: 'Football',
        captain: 'Amit K.',
        logoUrl: 'https://images.unsplash.com/photo-1543326727-cf6c39e8f84c?auto=format&fit=crop&q=80&w=200',
        colorHex: 'FF5733',
      ),
      const SportsTeam(
        id: 't3',
        name: 'HIT Strikers',
        sport: 'Cricket',
        captain: 'Rahul D.',
        logoUrl: 'https://images.unsplash.com/photo-1531415074968-036ba1b575da?auto=format&fit=crop&q=80&w=200',
        colorHex: '2196F3',
      ),
      const SportsTeam(
        id: 't4',
        name: 'Campus Titans',
        sport: 'Cricket',
        captain: 'Suresh R.',
        logoUrl: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e?auto=format&fit=crop&q=80&w=200',
        colorHex: 'FFC107',
      ),
    ]);

    notifyListeners();
  }

  void toggleFollowTeam(String teamId) {
    // This would typically integrate with AuthService
    // For now we just trigger a notification
    notifyListeners();
  }

  Future<void> refreshSports() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    await _initializeSports();
    _isLoading = false;
    notifyListeners();
  }
}
