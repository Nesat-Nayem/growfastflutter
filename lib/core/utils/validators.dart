class Validators {
  // utils/validators.dart

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Please enter your email";

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    if (!emailRegex.hasMatch(value)) return "Enter a valid email address";

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Please enter your password";

    if (value.length < 6) return "Password must be at least 6 characters";

    // Optional: Add more rules (uppercase, digit, special char)
    // final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$&*]).{6,}$');
    // if (!passwordRegex.hasMatch(value)) return "Password must contain uppercase, number and special character";

    return null;
  }
}
