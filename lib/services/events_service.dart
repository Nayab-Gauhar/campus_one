import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campus_one/models/event.dart';

/// Service responsible for managing event-related data and operations
class EventsService extends ChangeNotifier {
  List<EventModel> _events = [];
  List<String> _savedEventIds = [];
  bool _isLoading = false;

  List<EventModel> get events => _events;
  List<String> get savedEventIds => _savedEventIds;
  bool get isLoading => _isLoading;

  // Admin metrics
  int get activeEventCount => _events.where((e) => e.date.isAfter(DateTime.now())).length;

  EventsService() {
    _initializeEvents();
  }

  Future<void> _initializeEvents() async {
    _events = [
      EventModel(
        id: 'e1',
        title: 'Tech Hack-A-Thon',
        description: 'Build the future of campus tech in 24 hours. Compete with top minds and win exciting prizes!',
        date: DateTime.now().add(const Duration(days: 2, hours: 10)),
        location: 'Main Hall',
        organizerId: 's2',
        organizerName: 'Tech Club',
        imageUrl: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&q=80&w=800',
        category: EventCategory.hackathon,
        registrationDeadline: DateTime.now().add(const Duration(days: 1)),
        skillsToLearn: ['Flutter', 'Teamwork', 'Pitching'],
        targetAudience: 'All engineering students',
        status: EventStatus.published,
        contactName: 'Alex Chen',
        contactNumber: '+91 98765 43210',
        minTeamSize: 2,
        maxTeamSize: 4,
        agenda: [
          const EventAgendaItem(time: '09:00 AM', title: 'Opening Ceremony', description: 'Welcome address by the Dean.'),
          const EventAgendaItem(time: '10:00 AM', title: 'Hacking Begins', description: 'Start working on your projects.'),
          const EventAgendaItem(time: '01:00 PM', title: 'Lunch Break', description: 'Food provided at the cafeteria.'),
          const EventAgendaItem(time: '06:00 PM', title: 'Mentorship Round', description: 'Get feedback from industry experts.'),
        ],
        rules: [
          'Teams must consist of 2-4 members.',
          'All code must be written during the event.',
          'Open source libraries are allowed.',
        ],
      ),
      EventModel(
        id: 'e2',
        title: 'Annual Sports Meet',
        description: 'Compete in various sports including Athletics, Soccer and Cricket.',
        date: DateTime.now().add(const Duration(days: 5)),
        location: 'College Ground',
        organizerId: 's3',
        organizerName: 'Sports Council',
        imageUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&q=80&w=800',
        category: EventCategory.sports,
        registrationDeadline: DateTime.now().add(const Duration(days: 3)),
        skillsToLearn: ['Agility', 'Strategy'],
        targetAudience: 'Any student',
        status: EventStatus.published,
        contactName: 'Coach Mike',
        contactNumber: '+91 12345 67890',
        agenda: [
          const EventAgendaItem(time: '08:00 AM', title: 'Warm-up', description: 'Group exercises.'),
          const EventAgendaItem(time: '09:00 AM', title: 'Track Events', description: '100m, 200m, and Relay races.'),
          const EventAgendaItem(time: '02:00 PM', title: 'Team Sports', description: 'Football and Cricket finals.'),
        ],
        rules: [
          'Proper sports attire is mandatory.',
          'Registration ID card is required.',
        ],
      ),
    ];

    await _loadPersistedData();
    notifyListeners();
  }

  Future<void> _loadPersistedData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load event registrations
    final registeredString = prefs.getString('registered_events');
    if (registeredString != null) {
      final List<dynamic> registeredIds = jsonDecode(registeredString);
      for (var eventId in registeredIds) {
        final index = _events.indexWhere((e) => e.id == eventId);
        if (index != -1) {
          _events[index] = _events[index].copyWith(
            participantIds: List<String>.from(_events[index].participantIds)..add('1'),
          );
        }
      }
    }

    // Load saved events
    final savedString = prefs.getString('saved_events');
    if (savedString != null) {
      _savedEventIds = List<String>.from(jsonDecode(savedString));
    }
  }

  Future<void> _savePersistedData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final registeredIds = _events
        .where((e) => e.participantIds.contains('1'))
        .map((e) => e.id)
        .toList();
    await prefs.setString('registered_events', jsonEncode(registeredIds));
    await prefs.setString('saved_events', jsonEncode(_savedEventIds));
  }

  void registerForEvent(String eventId, String userId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      _events[index] = _events[index].copyWith(
        participantIds: List<String>.from(_events[index].participantIds)..add(userId),
      );
      _savePersistedData();
      notifyListeners();
    }
  }

  void addEvent(EventModel event) {
    _events.insert(0, event);
    notifyListeners();
  }

  void toggleSaveEvent(String eventId) {
    if (_savedEventIds.contains(eventId)) {
      _savedEventIds.remove(eventId);
    } else {
      _savedEventIds.add(eventId);
    }
    _savePersistedData();
    notifyListeners();
  }

  Future<void> refreshEvents() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    await _initializeEvents();
    _isLoading = false;
    notifyListeners();
  }
}
