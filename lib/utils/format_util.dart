import 'package:intl/intl.dart';
import 'package:get/get.dart';

class FormatUtil {
  static final _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    locale: 'en_IN',
    decimalDigits: 2,
  );

  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()} m';
    }
    return '${distanceInKm.toStringAsFixed(1)} km';
  }

  static String formatDuration(int durationInSeconds) {
    if (durationInSeconds < 60) {
      return '$durationInSeconds sec';
    }
    
    final minutes = durationInSeconds ~/ 60;
    if (minutes < 60) {
      return '$minutes min';
    }
    
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '$hours hr';
    }
    return '$hours hr $remainingMinutes min';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return '${formatDate(dateTime)} ${formatTime(dateTime)}';
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    }
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }
    return formatDate(dateTime);
  }

  static bool isValidPhoneNumber(String phone) {
    // Remove any non-digit characters
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    // Check if the phone number has 10 digits
    return digits.length == 10;
  }

  static bool isValidEmail(String email) {
    return GetUtils.isEmail(email);
  }

  static String formatPhoneNumber(String phone) {
    // Remove any non-digit characters
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    // Format as +91 XXXXXXXXXX
    if (digits.length == 10) {
      return '+91 ${digits}';
    }
    return phone;
  }

  static String formatVehicleNumber(String number) {
    // Convert to uppercase and remove any spaces
    return number.toUpperCase().replaceAll(' ', '');
  }
}