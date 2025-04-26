import 'package:get/get.dart';
import '../models/rider.dart';

class AuthController extends GetxController {
  final isLoggedIn = false.obs;
  final currentUser = Rxn<Rider>();

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    // TODO: Implement API call to check authentication status
    await Future.delayed(const Duration(seconds: 1));
    // For now, we'll just set to false
    isLoggedIn.value = false;
  }

  Future<void> login(String email, String password) async {
    // TODO: Implement API call to login
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock successful login
    isLoggedIn.value = true;
    currentUser.value = Rider(
      name: 'Rahul Kumar',
      email: email,
      phone: '9876543210',
      vehicleType: 'bike',
      vehicleNumber: 'KA 01 AB 1234',
      licenseNumber: 'DL98765432102021',
      password: password,
    );
    
    Get.offAllNamed('/home');
  }

  Future<void> logout() async {
    // TODO: Implement API call to logout
    await Future.delayed(const Duration(seconds: 1));
    
    isLoggedIn.value = false;
    currentUser.value = null;
    Get.offAllNamed('/login');
  }
} 