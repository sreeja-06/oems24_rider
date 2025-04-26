import 'package:get/get.dart';
import '../views/widgets/custom_dialog.dart';

class NetworkUtil {
  static void handleError(dynamic error) {
    final message = _getErrorMessage(error);
    CustomDialog.showError(
      context: Get.context!,
      title: 'Error',
      message: message,
    );
  }

  static void showSuccess(String message) {
    CustomDialog.showSuccess(
      context: Get.context!,
      title: 'Success',
      message: message,
    );
  }

  static String _getErrorMessage(dynamic error) {
    if (error is String) {
      return error;
    }
    
    if (error is Map) {
      return error['message'] as String? ?? 'An unexpected error occurred';
    }
    
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    
    return 'An unexpected error occurred';
  }

  static Future<bool> handleResponse(dynamic response) async {
    if (response == null) {
      handleError('No response from server');
      return false;
    }

    if (response is Map<String, dynamic>) {
      if (response['success'] == true) {
        if (response['message'] != null) {
          showSuccess(response['message'] as String);
        }
        return true;
      }
      
      handleError(response['message'] ?? 'Operation failed');
      return false;
    }

    return true;
  }

  static bool get hasInternetConnection => true; // TODO: Implement connectivity check

  static Future<bool> checkInternet() async {
    if (!hasInternetConnection) {
      handleError('No internet connection');
      return false;
    }
    return true;
  }

  static Map<String, String> getHeaders({bool requiresAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      // TODO: Add authentication token
      // headers['Authorization'] = 'Bearer ${StorageService.getToken()}';
    }

    return headers;
  }
}