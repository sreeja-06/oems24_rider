import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_constants.dart';
import '../../controllers/login_controller.dart';
import '../../utils/validation_util.dart';
import '../../routes/app_routes.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Login',
        showBackButton: false,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingWidget(message: 'Logging in...');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  const Icon(
                    Icons.local_taxi_outlined,
                    size: 80,
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Welcome Back!',
                    style: AppConstants.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Login to continue your journey with OEMS24',
                    style: AppConstants.captionStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  CustomTextField(
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: ValidationUtil.validatePhone,
                    prefixIcon: const Icon(Icons.phone),
                    maxLength: 10,
                    onChanged: controller.setPhoneNumber,
                  ),
                  const SizedBox(height: 16),
                  Obx(() => CustomTextField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: passwordController,
                    validator: ValidationUtil.validatePassword,
                    obscureText: !controller.isPasswordVisible.value,
                    prefixIcon: const Icon(Icons.lock),
                    maxLength: 10,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  )),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: 'Forgot Password?',
                      type: CustomButtonType.text,
                      onPressed: () {
                        // TODO: Implement forgot password
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Obx(() => CustomButton(
                    text: 'Login',
                    width: double.infinity,
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.login(
                              phoneController.text,
                              passwordController.text,
                            ),
                    isLoading: controller.isLoading.value,
                  )),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.signup),
                    child: const Text('Don\'t have an account? Sign up'),
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