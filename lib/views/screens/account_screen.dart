import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/account_controller.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/image_picker_widget.dart';

class AccountScreen extends GetView<AccountController> {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(AccountController());
    
    return WillPopScope(
      onWillPop: () async {
        if (controller.isLoading.value) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ImagePickerWidget(
                    imageUrl: controller.profileImageUrl.value,
                    pickedImage: controller.newProfileImage.value,
                    title: 'Profile Photo',
                    onPickImage: controller.pickProfileImage,
                    enabled: controller.isEditing.value,
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: controller.nameController,
                    label: 'Full Name',
                    enabled: controller.isEditing.value,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.phoneController,
                    label: 'Phone Number',
                    enabled: false, // Phone number should not be editable
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    enabled: controller.isEditing.value,
                  ),
                  const SizedBox(height: 16),
                  if (controller.isEditing.value)
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
                              onChanged: controller.isEditing.value
                                  ? (value) => controller.vehicleType.value = value!
                                  : null,
                            ),
                            RadioListTile<String>(
                              title: const Text('E-Bike'),
                              value: 'e-bike',
                              groupValue: controller.vehicleType.value,
                              onChanged: controller.isEditing.value
                                  ? (value) => controller.vehicleType.value = value!
                                  : null,
                            ),
                            RadioListTile<String>(
                              title: const Text('Cab'),
                              value: 'cab',
                              groupValue: controller.vehicleType.value,
                              onChanged: controller.isEditing.value
                                  ? (value) => controller.vehicleType.value = value!
                                  : null,
                            ),
                            RadioListTile<String>(
                              title: const Text('Premium Cab'),
                              value: 'premium cab',
                              groupValue: controller.vehicleType.value,
                              onChanged: controller.isEditing.value
                                  ? (value) => controller.vehicleType.value = value!
                                  : null,
                            ),
                            RadioListTile<String>(
                              title: const Text('Shuttle'),
                              value: 'shuttle',
                              groupValue: controller.vehicleType.value,
                              onChanged: controller.isEditing.value
                                  ? (value) => controller.vehicleType.value = value!
                                  : null,
                            ),
                            RadioListTile<String>(
                              title: const Text('Ambulance'),
                              value: 'ambulance',
                              groupValue: controller.vehicleType.value,
                              onChanged: controller.isEditing.value
                                  ? (value) => controller.vehicleType.value = value!
                                  : null,
                            ),
                          ],
                        )),
                      ],
                    )
                  else
                    CustomTextField(
                      controller: controller.vehicleTypeController,
                      label: 'Vehicle Type',
                      enabled: false,
                    ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: controller.vehicleNumberController,
                    label: 'Vehicle Number',
                    enabled: controller.isEditing.value,
                  ),
                  const SizedBox(height: 16),
                  Obx(() => Visibility(
                    visible: controller.needsVehicleRegImage(),
                    child: Column(
                      children: [
                        ImagePickerWidget(
                          imageUrl: controller.vehicleRegImageUrl.value,
                          pickedImage: controller.newVehicleRegImage.value,
                          title: 'Vehicle Registration Certificate',
                          onPickImage: controller.pickVehicleRegImage,
                          enabled: controller.isEditing.value,
                          isLicenseImage: true,
                          supportsPdf: true,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  )),
                  CustomTextField(
                    controller: controller.licenseNumberController,
                    label: 'License Number',
                    enabled: controller.isEditing.value,
                    validator: controller.validateLicenseNumber,
                  ),
                  const SizedBox(height: 16),
                  ImagePickerWidget(
                    imageUrl: controller.licenseImageUrl.value,
                    pickedImage: controller.newLicenseImage.value,
                    title: 'License Photo',
                    onPickImage: controller.pickLicenseImage,
                    enabled: controller.isEditing.value,
                    isLicenseImage: true,
                    supportsPdf: true,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: controller.isEditing.value ? 'Save' : 'Edit',
                          onPressed: controller.isEditing.value
                              ? () => controller.updateProfile()
                              : () => controller.toggleEditing(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Logout',
                          onPressed: controller.logout,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}