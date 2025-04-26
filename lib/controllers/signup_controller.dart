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

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validateVehicleNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your vehicle number';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password.value) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<bool> signup() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Validate all fields
      if (validateName(name.value) != null ||
          validateEmail(email.value) != null ||
          validatePhone(phone.value) != null ||
          validateVehicleNumber(vehicleNumber.value) != null ||
          validatePassword(password.value) != null ||
          validateConfirmPassword(confirmPassword.value) != null) {
        error.value = 'Please fill all fields correctly';
        return false;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Navigate to permissions screen
      Get.offAllNamed('/permissions');
      return true;
    } catch (e) {
      error.value = 'An error occurred during signup';
      return false;
    } finally {
      isLoading.value = false;
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
    super.onClose();
  }
}
