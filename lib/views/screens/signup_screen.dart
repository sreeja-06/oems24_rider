import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/signup_controller.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/image_picker_widget.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => ImagePickerWidget(
                  pickedImage: controller.profileImage.value,
                  title: 'Profile Photo',
                  onPickImage: controller.pickProfileImage,
                )),
                Obx(() => ImagePickerWidget(
                  pickedImage: controller.licenseImage.value,
                  title: 'License Photo',
                  onPickImage: controller.pickLicenseImage,
                  isLicenseImage: true,
                )),
              ],
            ),
            const SizedBox(height: 24),
            Obx(() => CustomTextField(
              label: 'Full Name',
              onChanged: (value) => controller.name.value = value,
              validator: controller.validateName,
              errorText: controller.validateName(controller.name.value),
            )),
            const SizedBox(height: 16),
            Obx(() => CustomTextField(
              label: 'Phone Number',
              onChanged: (value) => controller.phone.value = value,
              validator: controller.validatePhone,
              errorText: controller.validatePhone(controller.phone.value),
              keyboardType: TextInputType.phone,
            )),
            const SizedBox(height: 16),
            Obx(() => CustomTextField(
              label: 'Email',
              onChanged: (value) => controller.email.value = value,
              validator: controller.validateEmail,
              errorText: controller.validateEmail(controller.email.value),
              keyboardType: TextInputType.emailAddress,
            )),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vehicle Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Bike'),
                      value: 'bike',
                      groupValue: controller.vehicleType.value,
                      onChanged: (value) => controller.vehicleType.value = value!,
                    ),
                    RadioListTile<String>(
                      title: const Text('E-Bike'),
                      value: 'e-bike',
                      groupValue: controller.vehicleType.value,
                      onChanged: (value) => controller.vehicleType.value = value!,
                    ),
                    RadioListTile<String>(
                      title: const Text('Cab'),
                      value: 'cab',
                      groupValue: controller.vehicleType.value,
                      onChanged: (value) => controller.vehicleType.value = value!,
                    ),
                    RadioListTile<String>(
                      title: const Text('Premium Cab'),
                      value: 'premium cab',
                      groupValue: controller.vehicleType.value,
                      onChanged: (value) => controller.vehicleType.value = value!,
                    ),
                    RadioListTile<String>(
                      title: const Text('Shuttle'),
                      value: 'shuttle',
                      groupValue: controller.vehicleType.value,
                      onChanged: (value) => controller.vehicleType.value = value!,
                    ),
                    RadioListTile<String>(
                      title: const Text('Ambulance'),
                      value: 'ambulance',
                      groupValue: controller.vehicleType.value,
                      onChanged: (value) => controller.vehicleType.value = value!,
                    ),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => CustomTextField(
              label: 'Vehicle Number',
              onChanged: (value) => controller.vehicleNumber.value = value,
              validator: controller.validateVehicleNumber,
              errorText: controller.validateVehicleNumber(controller.vehicleNumber.value),
            )),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'License Number (Optional)',
              onChanged: (value) => controller.licenseNumber.value = value,
            ),
            const SizedBox(height: 16),
            Obx(() => CustomTextField(
              label: 'Password',
              onChanged: (value) => controller.password.value = value,
              validator: controller.validatePassword,
              errorText: controller.validatePassword(controller.password.value),
              obscureText: true,
            )),
            const SizedBox(height: 16),
            Obx(() => CustomTextField(
              label: 'Confirm Password',
              onChanged: (value) => controller.confirmPassword.value = value,
              validator: controller.validateConfirmPassword,
              errorText: controller.validateConfirmPassword(controller.confirmPassword.value),
              obscureText: true,
            )),
            const SizedBox(height: 24),
            Obx(() => CustomButton(
              text: 'Sign Up',
              onPressed: controller.isLoading.value ? null : () async {
                final success = await controller.signup();
                if (success) {
                  Get.offAllNamed('/permissions', arguments: {'isNewUser': true});
                }
              },
              isLoading: controller.isLoading.value,
            )),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () => Get.offNamed('/login'),
                  child: const Text('Login'),
                ),
              ],
            ),
            Obx(() {
              if (controller.error.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    controller.error.value,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
