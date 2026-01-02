class VerifyOtpParams {
  final String phone;
  final String otp;

  VerifyOtpParams({required this.phone, required this.otp});

  Map<String, dynamic> toJson() => {'phone': phone, 'otp': otp};
}
