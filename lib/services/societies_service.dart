import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campus_one/models/society.dart';

/// Service responsible for managing society-related data and operations
class SocietiesService extends ChangeNotifier {
  List<SocietyModel> _societies = [];
  bool _isLoading = false;

  List<SocietyModel> get societies => _societies;
  bool get isLoading => _isLoading;

  // Admin metrics
  int get totalPendingRequests {
    return _societies.fold(0, (sum, society) => sum + society.pendingRequests.length);
  }

  SocietiesService() {
    _initializeSocieties();
  }

  Future<void> _initializeSocieties() async {
    _societies = [
      SocietyModel(
        id: 's1',
        name: 'Photography Club',
        description: 'Capture the moments that define our campus life.',
        logoUrl: 'https://images.unsplash.com/photo-1542038784424-48ed70445c8b?auto=format&fit=crop&q=80&w=800',
        adminId: '2',
        category: 'Cultural',
        memberIds: [],
        pendingRequests: [],
        coreTeam: const {'President': 'John Smith', 'Secretary': 'Jane Doe'},
        whatWeDo: 'We organize photo walks, workshops, and exhibitions.',
        idealStudentProfile: 'Anyone with a passion for visual storytelling.',
        timeCommitment: '2-4 hours per week.',
        isRecruiting: true,
      ),
      SocietyModel(
        id: 's2',
        name: 'Tech Club',
        description: 'Building the next generation of software engineers.',
        logoUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&q=80&w=800',
        adminId: '2',
        category: 'Tech',
        memberIds: [],
        pendingRequests: [],
        whatWeDo: 'Coding workshops, hackathons, and project-based learning.',
        idealStudentProfile: 'Passionate coders and problem solvers.',
        timeCommitment: '5-8 hours per week.',
        isRecruiting: true,
      ),
    ];

    await _loadPersistedData();
    notifyListeners();
  }

  Future<void> _loadPersistedData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load society memberships
    final societyString = prefs.getString('joined_societies');
    if (societyString != null) {
      final List<dynamic> joinedIds = jsonDecode(societyString);
      for (var socId in joinedIds) {
        final index = _societies.indexWhere((s) => s.id == socId);
        if (index != -1) {
          _societies[index] = _societies[index].copyWith(
            memberIds: List<String>.from(_societies[index].memberIds)..add('1'),
          );
        }
      }
    }
  }

  Future<void> _savePersistedData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final joinedIds = _societies
        .where((s) => s.memberIds.contains('1'))
        .map((s) => s.id)
        .toList();
    await prefs.setString('joined_societies', jsonEncode(joinedIds));
  }

  void joinSociety(String societyId, String userId) {
    final index = _societies.indexWhere((s) => s.id == societyId);
    if (index != -1) {
      _societies[index] = _societies[index].copyWith(
        pendingRequests: List<String>.from(_societies[index].pendingRequests)..add(userId),
      );
      notifyListeners();
    }
  }

  void approveJoinRequest(String societyId, String userId) {
    final index = _societies.indexWhere((s) => s.id == societyId);
    if (index != -1) {
      _societies[index] = _societies[index].copyWith(
        memberIds: List<String>.from(_societies[index].memberIds)..add(userId),
        pendingRequests: List<String>.from(_societies[index].pendingRequests)..remove(userId),
      );
      _savePersistedData();
      notifyListeners();
    }
  }

  void rejectJoinRequest(String societyId, String userId) {
    final index = _societies.indexWhere((s) => s.id == societyId);
    if (index != -1) {
      _societies[index] = _societies[index].copyWith(
        pendingRequests: List<String>.from(_societies[index].pendingRequests)..remove(userId),
      );
      notifyListeners();
    }
  }

  Future<void> refreshSocieties() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    await _initializeSocieties();
    _isLoading = false;
    notifyListeners();
  }
}
