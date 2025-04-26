class ValidationUtil {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegExp = RegExp(r'^\d{10}$');
    
    if (!phoneRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid 10-digit phone number';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    return null;
  }

  static String? validateVehicleNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vehicle number is required';
    }
    
    // Format: KA 01 AB 1234
    final vehicleRegExp = RegExp(
      r'^[A-Z]{2}\s?\d{2}\s?[A-Z]{1,2}\s?\d{4}$',
    );
    
    if (!vehicleRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid vehicle number';
    }
    
    return null;
  }

  static String? validateLicenseNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'License number is required';
    }
    
    // Basic format validation for Indian driving license
    final licenseRegExp = RegExp(
      r'^[A-Z]{2}[0-9]{13}$',
    );
    
    if (!licenseRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid license number';
    }
    
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm password is required';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    }
    
    if (value.length != 6) {
      return 'Please enter a valid 6-digit OTP';
    }
    
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'OTP should only contain numbers';
    }
    
    return null;
  }
}