import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/network_util.dart';

class LoginController extends GetxController {
  final phoneNumber = ''.obs;
  final otp = ''.obs;
  final isOtpSent = false.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void setPhoneNumber(String number) {
    phoneNumber.value = number;
  }

  void setOtp(String code) {
    otp.value = code;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> _checkAndNavigatePermissions() async {
    final locationStatus = await Permission.location.status;
    final notificationStatus = await Permission.notification.status;
    
    // For login, only show permissions if they are not granted
    if (locationStatus.isDenied || locationStatus.isPermanentlyDenied ||
        notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
      Get.offAllNamed('/permissions', arguments: {'isNewUser': false});
    } else {
      Get.offAllNamed('/home');
    }
  }

  Future<void> sendOtp() async {
    if (phoneNumber.value.length != 10) {
      Get.snackbar(
        'Error',
        'Please enter a valid 10-digit phone number',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    // TODO: Implement actual OTP sending logic here
    await Future.delayed(const Duration(seconds: 2)); // Simulated delay
    isLoading.value = false;
    isOtpSent.value = true;
  }

  Future<void> verifyOtp() async {
    if (otp.value.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter a valid 6-digit OTP',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    // TODO: Implement actual OTP verification logic here
    await Future.delayed(const Duration(seconds: 2)); // Simulated delay
    isLoading.value = false;
    
    // Navigate to permissions screen after successful verification
    Get.offNamed('/permissions');
  }

  Future<void> login(String phone, String password) async {
    try {
      isLoading.value = true;

      // TODO: Implement actual login API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (phone == '1234567890' && password == 'password') {
        NetworkUtil.showSuccess('Login successful');
        await _checkAndNavigatePermissions();
      } else {
        NetworkUtil.handleError('Invalid phone number or password');
      }
    } catch (e) {
      NetworkUtil.handleError(e);
    } finally {
      isLoading.value = false;
    }
  }
}