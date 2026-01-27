class SendOtpResponse {
  final int userId;
  final bool isTest;
  final String? testOtp;

  SendOtpResponse({
    required this.userId,
    this.isTest = false,
    this.testOtp,
  });
}
