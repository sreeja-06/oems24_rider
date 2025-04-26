import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: controller.markAllAsRead,
            child: const Text('Mark all as read', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Obx(() => controller.notifications.isEmpty
        ? const Center(
            child: Text('No notifications'),
          )
        : ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return ListTile(
                leading: Icon(notification.icon),
                title: Text(notification.title),
                subtitle: Text(notification.message),
                trailing: Text(notification.timeAgo),
                onTap: () => controller.markAsRead(notification.id),
              );
            },
          ),
      ),
    );
  }
}
