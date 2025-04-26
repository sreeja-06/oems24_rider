import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final notifications = <Notification>[].obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Add some mock notifications
    addNotification(
      'New Feature Available',
      'You can now track your earnings in real-time!',
      Icons.star,
    );
    addNotification(
      'Weekly Summary',
      'You completed 25 rides this week. Great job!',
      Icons.assessment,
    );
  }

  void addNotification(String title, String message, IconData icon) {
    notifications.insert(0, Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      icon: icon,
      timestamp: DateTime.now(),
      isRead: false,
    ));
    _updateUnreadCount();
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final notification = notifications[index];
      notifications[index] = notification.copyWith(isRead: true);
      _updateUnreadCount();
    }
  }

  void markAllAsRead() {
    notifications.assignAll(
      notifications.map((n) => n.copyWith(isRead: true)).toList(),
    );
    _updateUnreadCount();
  }

  void removeNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    _updateUnreadCount();
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }
}

class Notification {
  final String id;
  final String title;
  final String message;
  final IconData icon;
  final DateTime timestamp;
  final bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.timestamp,
    this.isRead = false,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }

  Notification copyWith({bool? isRead}) {
    return Notification(
      id: id,
      title: title,
      message: message,
      icon: icon,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
