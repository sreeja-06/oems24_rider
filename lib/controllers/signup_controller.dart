import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// TODO: Uncomment when implementing API integration
// import '../models/rider.dart';

class SignupController extends GetxController {
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString phone = ''.obs;
  final RxString vehicleType = 'bike'.obs;
  final RxString vehicleNumber = ''.obs;
  final RxString password = ''.obs;
  final RxString confirmPassword = ''.obs;
  final RxString licenseNumber = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rxn<XFile> profileImage = Rxn<XFile>();
  final Rxn<XFile> licenseImage = Rxn<XFile>();
  final Rx<XFile?> vehicleRegImage = Rx<XFile?>(null);

  final ImagePicker _picker = ImagePicker();

  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (image != null) {
        profileImage.value = image;
      }
    } catch (e) {
      error.value = 'Failed to pick profile image';
    }
  }

  Future<void> pickLicenseImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 90,
      );
      if (image != null) {
        licenseImage.value = image;
      }
    } catch (e) {
      error.value = 'Failed to pick license image';
    }
  }

  Future<void> pickVehicleRegImage() async {
    try {
      final XFile? image = await _picker.pickMedia();
      if (image != null) {
        vehicleRegImage.value = image;
      }
    } catch (e) {
      error.value = 'Failed to pick vehicle registration image';
    }
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  String? validateVehicleNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vehicle number is required';
    }
    return null;
  }

  String? validateLicenseNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'License number is required';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }
    if (value != password.value) {
      return 'Passwords do not match';
    }
    return null;
  }

  bool needsVehicleRegImage() {
    return vehicleType.value != 'e-bike';
  }

  bool validateInputs() {
    if (validateName(name.value) != null ||
        validatePhone(phone.value) != null ||
        validateEmail(email.value) != null ||
        validateVehicleNumber(vehicleNumber.value) != null ||
        validateLicenseNumber(licenseNumber.value) != null ||
        validatePassword(password.value) != null ||
        validateConfirmPassword(confirmPassword.value) != null) {
      return false;
    }
    
    if (profileImage.value == null) {
      error.value = 'Please upload a profile photo';
      return false;
    }
    
    if (licenseImage.value == null) {
      error.value = 'Please upload a license photo';
      return false;
    }
    
    if (needsVehicleRegImage() && vehicleRegImage.value == null) {
      error.value = 'Please upload vehicle registration certificate';
      return false;
    }
    
    return true;
  }

  Future<bool> signup() async {
    error.value = '';
    
    if (!validateInputs()) {
      return false;
    }
    
    isLoading.value = true;
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Replace with actual API call for signup
      
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      error.value = 'Failed to sign up: ${e.toString()}';
      return false;
    }
  }

  @override
  void onClose() {
    name.close();
    email.close();
    phone.close();
    vehicleType.close();
    vehicleNumber.close();
    password.close();
    confirmPassword.close();
    licenseNumber.close();
    isLoading.close();
    error.close();
    profileImage.close();
    licenseImage.close();
    vehicleRegImage.close();
    super.onClose();
  }
}
