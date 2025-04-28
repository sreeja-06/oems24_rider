import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_controller.dart';

class PermissionsController extends GetxController {
  final RxInt currentPermissionIndex = 0.obs;
  final RxBool isLocationGranted = false.obs;
  final RxBool isNotificationGranted = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    final locationStatus = await Permission.location.status;
    final notificationStatus = await Permission.notification.status;
    
    isLocationGranted.value = locationStatus.isGranted;
    isNotificationGranted.value = notificationStatus.isGranted;
    
    if (isLocationGranted.value) {
      currentPermissionIndex.value = 1;
      if (isNotificationGranted.value) {
        currentPermissionIndex.value = 2;
      }
    }
  }

  Future<void> requestLocationPermission() async {
    isLoading.value = true;
    
    // First check if permission is permanently denied
    if (await Permission.location.isPermanentlyDenied) {
      Get.snackbar(
        'Location Required',
        'Location permission is required. Please enable it in settings.',
        snackPosition: SnackPosition.TOP,
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
        snackPosition: SnackPosition.TOP,
      );
      isLoading.value = false;
      return;
    }

    if (status.isGranted) {
      // Move to next permission if granted
      currentPermissionIndex.value = 1;
      // Small delay for smooth transition
      await Future.delayed(const Duration(milliseconds: 500));
    } else {
      // Show message that location is required
      Get.snackbar(
        'Location Required',
        'Location permission is required to use this app',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    }
    
    isLoading.value = false;
  }

  Future<void> requestNotificationPermission() async {
    isLoading.value = true;
    
    // First check if permission is permanently denied
    if (await Permission.notification.isPermanentlyDenied) {
      Get.snackbar(
        'Notifications Required',
        'Notification permission is required. Please enable it in settings.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text('Open Settings'),
        ),
      );
      isLoading.value = false;
      return;
    }
    
    // Request notification permission
    final status = await Permission.notification.request();
    isNotificationGranted.value = status.isGranted;
    
    if (status.isGranted) {
      // Only move to completion step if notification is granted
      currentPermissionIndex.value = 2;
      // Small delay for smooth transition
      await Future.delayed(const Duration(milliseconds: 500));
    } else {
      // Show message that notifications are required
      Get.snackbar(
        'Notifications Required',
        'Please enable notifications to receive ride requests',
        snackPosition: SnackPosition.TOP,
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
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    
    if (!isNotificationGranted.value) {
      Get.snackbar(
        'Permission Required',
        'Notifications are required to receive ride requests',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    
    // Ensure the home tab is selected when navigating to home
    final HomeController homeController = Get.find<HomeController>();
    homeController.currentIndex.value = 0; // Set to home tab (index 0)
    
    Get.offAllNamed('/home');
  }

  bool get canProceed => currentPermissionIndex.value == 2 && 
                        isLocationGranted.value && 
                        isNotificationGranted.value;
}