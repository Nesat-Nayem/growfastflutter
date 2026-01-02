class SendOtpParams {
  final String phone;

  SendOtpParams({required this.phone});

  Map<String, dynamic> toJson() => {'phone': phone};
}
