import 'package:flutter/material.dart';
import 'package:campus_one/models/notification.dart';

/// Service responsible for managing notification-related data and operations
class NotificationsService extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  // Convenience getter for unread notifications count
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationsService() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    _notifications = [
      NotificationModel(
        id: 'n1',
        title: 'Registration confirmed',
        message: 'You are in for the Tech Hack-A-Thon! Check your email for details.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.eventUpdate,
        isRead: false,
      ),
      NotificationModel(
        id: 'n2',
        title: 'Membership Approved',
        message: 'Welcome to the Photography Club! We are excited to have you.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.statusUpdate,
        isRead: true,
      ),
    ];

    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  Future<void> refreshNotifications() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    await _initializeNotifications();
    _isLoading = false;
    notifyListeners();
  }
}
