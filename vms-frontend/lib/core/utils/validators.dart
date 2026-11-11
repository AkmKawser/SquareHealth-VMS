class Validators {
  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? vehicleNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vehicle number is required';
    }
    final clean = value.trim().toUpperCase();
    if (clean.length < 5) {
      return 'Vehicle number must be at least 5 characters';
    }
    final regex = RegExp(r'^[A-Z0-9-]+$');
    if (!regex.hasMatch(clean)) {
      return 'Must contain only uppercase letters, numbers, and hyphens';
    }
    return null;
  }

  static String? emailOrUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username or email is required';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }
}
