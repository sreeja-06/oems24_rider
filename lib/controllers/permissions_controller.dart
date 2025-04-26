import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsController extends GetxController {
  final isLocationGranted = false.obs;
  final isNotificationGranted = false.obs;
  final currentPermissionIndex = 0.obs;
  final isLoading = false.obs;

  Future<void> requestLocationPermission() async {
    isLoading.value = true;
    
    // First check if permission is permanently denied
    if (await Permission.location.isPermanentlyDenied) {
      Get.snackbar(
        'Location Required',
        'Location permission is required. Please enable it in settings.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text('Open Settings'),
        ),
      );
      isLoading.value = false;
      return;
    }

    // Request location permission
    final status = await Permission.location.request();
    isLocationGranted.value = status.isGranted;
    
    if (status.isDenied) {
      Get.snackbar(
        'Permission Required',
        'Location permission is required to use the app',
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
      return;
    }

    if (status.isGranted) {
      // If location granted, automatically request notification permission
      currentPermissionIndex.value = 1;
      await Future.delayed(const Duration(milliseconds: 500)); // Small delay for smooth transition
      await requestNotificationPermission();
    }
    
    isLoading.value = false;
  }

  Future<void> requestNotificationPermission() async {
    isLoading.value = true;
    
    // Request notification permission
    final status = await Permission.notification.request();
    isNotificationGranted.value = status.isGranted;
    
    if (status.isGranted) {
      // Only move to completion step if notification is granted
      currentPermissionIndex.value = 2;
    } else {
      // Show message that notifications are required
      Get.snackbar(
        'Notifications Required',
        'Please enable notifications to receive ride requests',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
    
    isLoading.value = false;
  }

  void proceedToHome() {
    if (!isLocationGranted.value) {
      Get.snackbar(
        'Permission Required',
        'Location permission is required to proceed',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    if (!isNotificationGranted.value) {
      Get.snackbar(
        'Permission Required',
        'Notifications are required to receive ride requests',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    Get.offAllNamed('/home');
  }

  bool get canProceed => currentPermissionIndex.value == 2 && 
                        isLocationGranted.value && 
                        isNotificationGranted.value;
}