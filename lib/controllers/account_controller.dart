import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/rider.dart';
import '../utils/format_util.dart';

class AccountController extends GetxController {
  final name = ''.obs;
  final phone = ''.obs;
  final email = ''.obs;
  final vehicleType = 'bike'.obs;
  final vehicleNumber = ''.obs;
  final licenseNumber = ''.obs;
  final isLoading = true.obs;
  final isEditing = false.obs;
  final profileImageUrl = RxnString();
  final licenseImageUrl = RxnString();
  final Rxn<XFile> newProfileImage = Rxn<XFile>();
  final Rxn<XFile> newLicenseImage = Rxn<XFile>();

  // Form controllers
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final vehicleNumberController = TextEditingController();
  final licenseNumberController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    // TODO: Implement API call to fetch profile data
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data
    name.value = 'Rahul Kumar';
    phone.value = '9876543210';
    email.value = 'rahul.k@example.com';
    vehicleType.value = 'bike';
    vehicleNumber.value = 'KA 01 AB 1234';
    licenseNumber.value = 'DL98765432102021';
    profileImageUrl.value = 'https://example.com/profile.jpg'; // Mock URL
    licenseImageUrl.value = 'https://example.com/license.jpg'; // Mock URL
    
    // Set controller values
    nameController.text = name.value;
    phoneController.text = FormatUtil.formatPhoneNumber(phone.value);
    emailController.text = email.value;
    vehicleTypeController.text = vehicleType.value;
    vehicleNumberController.text = FormatUtil.formatVehicleNumber(vehicleNumber.value);
    licenseNumberController.text = licenseNumber.value;
    
    isLoading.value = false;
  }

  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (image != null) {
        newProfileImage.value = image;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick profile image');
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
        newLicenseImage.value = image;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick license image');
    }
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    // TODO: Implement API call to update profile
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Upload new images if selected
    if (newProfileImage.value != null) {
      // Mock upload
      profileImageUrl.value = 'https://example.com/new_profile.jpg';
    }
    
    if (newLicenseImage.value != null) {
      // Mock upload
      licenseImageUrl.value = 'https://example.com/new_license.jpg';
    }
    
    name.value = nameController.text;
    email.value = emailController.text;
    vehicleNumber.value = vehicleNumberController.text;
    licenseNumber.value = licenseNumberController.text;
    
    isLoading.value = false;
    isEditing.value = false;
    
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
      duration: const Duration(seconds: 3),
    );
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      // Reset new images if editing is cancelled
      newProfileImage.value = null;
      newLicenseImage.value = null;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulated logout delay
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    vehicleTypeController.dispose();
    vehicleNumberController.dispose();
    licenseNumberController.dispose();
    super.onClose();
  }
}