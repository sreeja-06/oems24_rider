import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const primaryColor = Color(0xFF1976D2);
  static const secondaryColor = Color(0xFF2196F3);
  static const successColor = Color(0xFF4CAF50);
  static const warningColor = Color(0xFFFFC107);
  static const dangerColor = Color(0xFFF44336);
  static const backgroundColor = Color(0xFFF5F5F5);

  // Dimensions
  static const double defaultMargin = 16.0;
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double buttonRadius = 8.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;

  // Text Styles
  static const titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.15,
  );

  static const subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  static const bodyStyle = TextStyle(
    fontSize: 16,
    letterSpacing: 0.5,
  );

  static const captionStyle = TextStyle(
    fontSize: 12,
    letterSpacing: 0.4,
  );

  // Animation Durations
  static const animationDuration = Duration(milliseconds: 300);
  static const snackBarDuration = Duration(seconds: 3);

  // API Constants
  static const apiBaseUrl = 'https://api.example.com'; // TODO: Update with actual API URL
  static const apiTimeout = Duration(seconds: 30);

  // Storage Keys
  static const tokenKey = 'auth_token';
  static const userKey = 'user_data';
  static const themeKey = 'app_theme';
  static const localeKey = 'app_locale';

  // Map Constants
  static const defaultZoom = 15.0;
  static const defaultLatitude = 12.9716;  // Bangalore
  static const defaultLongitude = 77.5946;

  // Validation Constants
  static const phoneNumberLength = 10;
  static const minPasswordLength = 6;
  static const otpLength = 6;

  // Image Assets
  static const logoPath = 'assets/images/logo.png';
  static const markerIconPath = 'assets/images/marker.png';
  static const placeholderAvatarPath = 'assets/images/avatar.png';

  // App Settings
  static const appName = 'Captain App';
  static const appVersion = '1.0.0';
  static const supportEmail = 'support@example.com';
  static const supportPhone = '+1234567890';

  static double borderRadius = 8.0; // Default border radius

  static var headingStyle;
}

class AppAssets {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String placeholder = 'assets/images/placeholder.png';
  
  // Icons
  static const String markerIcon = 'assets/images/marker.png';
  static const String carIcon = 'assets/images/car.png';
}