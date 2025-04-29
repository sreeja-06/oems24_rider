import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/account_controller.dart';
import '../../views/widgets/custom_text_field.dart';
import '../../views/widgets/custom_button.dart';
import '../../views/widgets/image_picker_widget.dart';
import '../../constants/app_constants.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountController>();
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (controller.isEditing.value) {
          controller.toggleEditing();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          actions: [
            Obx(() => controller.isEditing.value
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => controller.toggleEditing(),
                  )
                : IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => controller.toggleEditing(),
                  )),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture with improved styling
                    Hero(
                      tag: 'profile_image',
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ImagePickerWidget(
                          size: 120,
                          imageUrl: controller.profileImageUrl.value?.isEmpty ?? true
                              ? null
                              : controller.profileImageUrl.value,
                          onPickImage: controller.isEditing.value
                              ? controller.pickProfileImage
                              : null,
                          title: 'Profile Photo',
                        ),
                      ),
                    ),

                    // Driver info card with elevation
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Full Name
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.isEditing.value
                                    ? theme.colorScheme.surface
                                    : Colors.transparent,
                              ),
                              child: CustomTextField(
                                controller: controller.nameController,
                                label: 'Full Name',
                                enabled: controller.isEditing.value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            // Phone Number
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.isEditing.value
                                    ? theme.colorScheme.surface
                                    : Colors.transparent,
                              ),
                              child: CustomTextField(
                                controller: controller.phoneController,
                                label: 'Phone Number',
                                enabled: false,
                                keyboardType: TextInputType.phone,
                              ),
                            ),

                            // Email
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.isEditing.value
                                    ? theme.colorScheme.surface
                                    : Colors.transparent,
                              ),
                              child: CustomTextField(
                                controller: controller.emailController,
                                label: 'Email',
                                enabled: controller.isEditing.value,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!GetUtils.isEmail(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Vehicle info card with elevation
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                              child: Text(
                                'Vehicle Type',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // Vehicle Type RadioListTile with custom styling
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.isEditing.value
                                    ? (controller.vehicleType.value == 'bike'
                                        ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                                        : theme.colorScheme.surface)
                                    : Colors.transparent,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  listTileTheme: ListTileThemeData(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                child: RadioListTile<String>(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.pedal_bike,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Bike',
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  value: 'bike',
                                  groupValue: controller.vehicleType.value,
                                  onChanged: controller.isEditing.value
                                      ? (value) {
                                          if (value != null) {
                                            controller.vehicleType.value = value;
                                          }
                                        }
                                      : null,
                                  activeColor: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.isEditing.value
                                    ? (controller.vehicleType.value == 'e-bike'
                                        ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                                        : theme.colorScheme.surface)
                                    : Colors.transparent,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  listTileTheme: ListTileThemeData(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                child: RadioListTile<String>(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.electric_bike,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'E-Bike',
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  value: 'e-bike',
                                  groupValue: controller.vehicleType.value,
                                  onChanged: controller.isEditing.value
                                      ? (value) {
                                          if (value != null) {
                                            controller.vehicleType.value = value;
                                          }
                                        }
                                      : null,
                                  activeColor: theme.colorScheme.primary,
                                ),
                              ),
                            ),

                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.isEditing.value
                                    ? (controller.vehicleType.value == 'cab'
                                        ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                                        : theme.colorScheme.surface)
                                    : Colors.transparent,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  listTileTheme: ListTileThemeData(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                child: RadioListTile<String>(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.local_taxi,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Cab',
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  value: 'cab',
                                  groupValue: controller.vehicleType.value,
                                  onChanged: controller.isEditing.value
                                      ? (value) {
                                          if (value != null) {
                                            controller.vehicleType.value = value;
                                          }
                                        }
                                      : null,
                                  activeColor: theme.colorScheme.primary,
                                ),
                              ),
                            ),

                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.isEditing.value
                                    ? (controller.vehicleType.value == 'premium cab'
                                        ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                                        : theme.colorScheme.surface)
                                    : Colors.transparent,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  listTileTheme: ListTileThemeData(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                child: RadioListTile<String>(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.airport_shuttle,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Premium Cab',
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  value: 'premium cab',
                                  groupValue: controller.vehicleType.value,
                                  onChanged: controller.isEditing.value
                                      ? (value) {
                                          if (value != null) {
                                            controller.vehicleType.value = value;
                                          }
                                        }
                                      : null,
                                  activeColor: theme.colorScheme.primary,
                                ),
                              ),
                            ),

                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.isEditing.value
                                    ? (controller.vehicleType.value == 'shuttle'
                                        ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                                        : theme.colorScheme.surface)
                                    : Colors.transparent,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  listTileTheme: ListTileThemeData(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                child: RadioListTile<String>(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.directions_bus,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Shuttle',
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  value: 'shuttle',
                                  groupValue: controller.vehicleType.value,
                                  onChanged: controller.isEditing.value
                                      ? (value) {
                                          if (value != null) {
                                            controller.vehicleType.value = value;
                                          }
                                        }
                                      : null,
                                  activeColor: theme.colorScheme.primary,
                                ),
                              ),
                            ),

                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.isEditing.value
                                    ? (controller.vehicleType.value == 'ambulance'
                                        ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                                        : theme.colorScheme.surface)
                                    : Colors.transparent,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  listTileTheme: ListTileThemeData(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                child: RadioListTile<String>(
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.emergency,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Ambulance',
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                  value: 'ambulance',
                                  groupValue: controller.vehicleType.value,
                                  onChanged: controller.isEditing.value
                                      ? (value) {
                                          if (value != null) {
                                            controller.vehicleType.value = value;
                                          }
                                        }
                                      : null,
                                  activeColor: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            
                            // Vehicle Number field
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 16, top: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.isEditing.value
                                    ? theme.colorScheme.surface
                                    : Colors.transparent,
                              ),
                              child: CustomTextField(
                                controller: controller.vehicleNumberController,
                                label: 'Vehicle Number',
                                enabled: controller.isEditing.value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your vehicle number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            
                            // Vehicle Registration Certificate (if not e-bike)
                            Obx(() => Visibility(
                              visible: controller.needsVehicleRegImage(),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ImagePickerWidget(
                                  pickedImage: controller.newVehicleRegImage.value,
                                  imageUrl: controller.vehicleRegImageUrl.value,
                                  title: 'Vehicle Registration Certificate',
                                  onPickImage: controller.isEditing.value
                                      ? controller.pickVehicleRegImage
                                      : null,
                                  isLicenseImage: true,
                                  supportsPdf: true,
                                ),
                              ),
                            )),
                            
                            // License Number field
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: controller.isEditing.value
                                    ? theme.colorScheme.surface
                                    : Colors.transparent,
                              ),
                              child: CustomTextField(
                                controller: controller.licenseNumberController,
                                label: 'License Number',
                                enabled: controller.isEditing.value,
                                validator: controller.validateLicenseNumber,
                              ),
                            ),
                            
                            // License Photo
                            ImagePickerWidget(
                              pickedImage: controller.newLicenseImage.value,
                              imageUrl: controller.licenseImageUrl.value,
                              title: 'License Photo',
                              onPickImage: controller.isEditing.value
                                  ? controller.pickLicenseImage
                                  : null,
                              isLicenseImage: true,
                              supportsPdf: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    Obx(() => controller.isEditing.value
                        ? Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'Cancel',
                                  onPressed: () => controller.toggleEditing(),
                                  color: Colors.white,
                                  textColor: Colors.black87,
                                  type: CustomButtonType.outline,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomButton(
                                  text: 'Save',
                                  onPressed: () => controller.updateProfile(),
                                  isLoading: controller.isLoading.value,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomButton(
                                text: 'Logout',
                                onPressed: () => controller.logout(),
                                color: AppConstants.dangerColor,
                              ),
                            ],
                          )),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}