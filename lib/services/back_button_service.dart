import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BackButtonService {
  static void init() {
    // Set up Android back button behavior
    SystemChannels.platform.setMethodCallHandler((call) async {
      if (call.method == 'SystemNavigator.pop') {
        // For Android specific back button behavior
        return _handleBackButton();
      }
      return null;
    });
  }

  static Future<bool> _handleBackButton() async {
    // Check if any dialog is showing
    if (Get.isDialogOpen ?? false) {
      Get.back();
      return true;
    }
    
    // Check if any bottom sheet is showing
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
      return true;
    }
    
    // Check if we can go back in navigation
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
      return true;
    }
    
    // If we're on the root screen, show exit confirmation
    if (Get.currentRoute == '/home' || Get.currentRoute == '/') {
      final shouldExit = await _showExitConfirmation();
      return shouldExit;
    }
    
    return false;
  }
  
  static Future<bool> _showExitConfirmation() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
} 